'use strict';
const Service = require('egg').Service;
const path = require('path');
const fs = require('fs/promises');
const fsSync = require('fs');
const fse = require('fs-extra');
const { Op } = require('sequelize');
class GenerateService extends Service {
	// 生成模型
	async models(uuid) {
		const { ctx } = this;
		// 获取模型信息
		const modInfo = await ctx.model.SysModels.findOne({ where: { uuid } });
		const className = ctx.helper._.upperFirst(ctx.helper._.camelCase(modInfo.name));
		const tableName = modInfo.name;
		// 获取字段
		const fieldList = await ctx.model.SysModelsFields.findAll({ where: { models_uuid: uuid }, order: [['sort', 'ASC']] });
		// console.log(fieldList);

		let flist = '';
		for (const v of fieldList) {
			const comment = `, comment: '${v.comment}'`;
			let defaultValue = '';
			let type = '';
			let autoIncrement = '';
			let primaryKey = '';
            let allowNull = !!v.allowNull? ', allowNull: false' : '';
			if (v.primaryKey) {
				primaryKey = `, primaryKey: ${v.primaryKey}`;
			}
			if (v.type === 'UUID') {
				if (v.uuidtype === 'UUIDV4' || v.uuidtype === 'UUIDV1') {
					defaultValue = `, defaultValue: DataTypes.${v.uuidtype}`;
				}
			} else if (v.type === 'BOOLEAN') {
				if (v.booleantype) {
					defaultValue = `, defaultValue: ${v.booleantype}`;
				}
			} else if (v.type === 'DATE') {
				if (v.defaulttonow) {
					defaultValue = ', defaultValue: DataTypes.NOW';
				}
			} else if (v.type === 'TEXT' || v.type === 'JSON' || v.type === 'DATEONLY') {
				defaultValue = '';
			} else if (v.type === 'ENUM' || v.type === 'STRING') {
				if (v.defaultValue) {
                    if (v.defaultValue === '空字符串') {
                        defaultValue = ", defaultValue: ''";
                    } else {
                        defaultValue = `, defaultValue: '${v.defaultValue}'`;
                    }
				}
			} else if (!ctx.helper._.isEmpty(v.defaultValue) && (ctx.helper.isStringNumber(v.defaultValue) || v.defaultValue === 'null')) {
				defaultValue = `, defaultValue: ${v.defaultValue}`;
			} else if (!ctx.helper._.isEmpty(v.defaultValue)) {
				defaultValue = `, defaultValue: '${v.defaultValue}'`;
			}
			if (v.type === 'STRING' || v.type === 'DATE') {
				if (v.lengths) {
					type = `type: DataTypes.${v.type}(${v.lengths})`;
				} else {
					type = `type: DataTypes.${v.type}`;
				}
			} else if (v.type === 'ENUM' && v.enumValue) {
				const evarr = v.enumValue.split('\n');
				type = `type: DataTypes.${v.type}, values: ${JSON.stringify(evarr)}`;
			} else if (v.type === 'INTEGER' || v.type === 'BIGINT') {
				const tt = `type: DataTypes.${v.type}`;
				if (v.unsigned && v.zerofill) {
					type = `${tt}.UNSIGNED.ZEROFILL`;
				} else if (v.unsigned) {
					type = `${tt}.UNSIGNED`;
				} else if (v.zerofill) {
					type = `${tt}.ZEROFILL`;
				} else {
					type = `${tt}`;
				}
				if (v.lengths) {
					type = `${type}(${v.lengths})`;
				}
				if (v.autoIncrement) {
					autoIncrement = `, autoIncrement:${v.autoIncrement}`;
				}
			} else if (v.type === 'FLOAT' || v.type === 'DOUBLE' || v.type === 'DECIMAL') {
				const tt = `type: DataTypes.${v.type}`;
				if (v.unsigned && v.zerofill) {
					type = `${tt}.UNSIGNED.ZEROFILL`;
				} else if (v.unsigned) {
					type = `${tt}.UNSIGNED`;
				} else if (v.zerofill) {
					type = `${tt}.ZEROFILL`;
				} else {
					type = `${tt}`;
				}
				if (v.lengths && v.point) {
					type = `${type}(${v.lengths},${v.point})`;
				} else if (v.lengths) {
					type = `${type}(${v.lengths})`;
				}
				if (v.autoIncrement && (v.type === 'FLOAT' || v.type === 'DOUBLE')) {
					autoIncrement = `, autoIncrement:${v.autoIncrement}`;
				}
			} else {
				type = `type: DataTypes.${v.type}`;
			}
			flist += `		${v.name}: { ${type}${allowNull}${defaultValue}${autoIncrement}${primaryKey}${comment} },` + '\n';
		}
		const modIndexes = await ctx.model.SysModelsIndexes.findAll({ where: { models_uuid: uuid }, order: [['sort', 'ASC']] });
		const indexesobj = [];
		for (const v of modIndexes) {
			const obj = {};
			obj.unique = v.unique;
			const indexsField = await ctx.model.SysModelsFields.findAll({ where: { uuid: { [Op.in]: v.fields.split(',') } } });
			const farr = [];
			for (const f of indexsField) {
				farr.push(f.name);
			}
			obj.fields = farr;
			indexesobj.push(obj);
		}
		// console.log(indexesobj);
		let indexesStr = '';
		if (indexesobj.length > 0) {
			indexesStr = `indexes:${JSON.stringify(indexesobj)},`;
		}
		const modAssociate = await ctx.model.SysModelsAssociate.findAll({ where: { models_uuid: uuid }, order: [['sort', 'ASC']] });
		// console.log(modAssociate);
		let associateStr = '';
		if (modAssociate.length > 0) {
			let astr = '';
			for (const v of modAssociate) {
				const parent_uuid = await ctx.model.SysModels.findOne({ where: { uuid: v.parent_uuid } });
				const child_uuid = await ctx.model.SysModels.findOne({ where: { uuid: v.child_uuid } });
				const target_key = await ctx.model.SysModelsFields.findOne({ where: { uuid: v.targetKey } });
				const foreign_key = await ctx.model.SysModelsFields.findOne({ where: { uuid: v.foreignKey } });
				const parent = ctx.helper._.upperFirst(ctx.helper._.camelCase(parent_uuid.name));
				const child = ctx.helper._.upperFirst(ctx.helper._.camelCase(child_uuid.name));
				const targetKey = target_key.name;
				const foreignKey = foreign_key.name;
				if (v.type === 'HasOne' || v.type === 'HasMany') {
					astr += [
						`		app.model.${parent}.${ctx.helper._.lowerFirst(v.type)}(app.model.${child}, {`,
						`			foreignKey: '${foreignKey}',`,
						`			sourceKey: '${targetKey}',`,
						`			constraints: ${v.constraints},`,
						v.alias ? `			as: '${v.alias}'` : '',
						'		});\n'
					].join('\n');
				}
				if (v.type === 'BelongsTo') {
					astr += [
						`		app.model.${child}.belongsTo(app.model.${parent}, {`,
						`			foreignKey: '${foreignKey}',`,
						`			targetKey: '${targetKey}',`,
						`			constraints: ${v.constraints},`,
						v.alias ? `			as: '${v.alias}'` : '',
						'		});\n'
					].join('\n');
				}
				if (v.type === 'BelongsToMany') {
					const through_uuid = await ctx.model.SysModels.findOne({ where: { uuid: v.through_uuid } });
					const through = ctx.helper._.upperFirst(ctx.helper._.camelCase(through_uuid.name));
					const through_key = await ctx.model.SysModelsFields.findOne({ where: { uuid: v.throughKey } });
					const throughKey = through_key.name;
					astr += [
						`		app.model.${parent}.belongsToMany(app.model.${child}, {`,
						`			through: { model: app.model.${through}, unique: false },`,
						`			foreignKey: '${throughKey}',`,
						`			sourceKey: '${targetKey}',`,
						`			targetKey: '${foreignKey}',`,
						`			constraints: ${v.constraints},`,
						v.alias ? `			as: '${v.alias}'` : '',
						'		});\n'
					].join('\n');
				}
			}
			associateStr = [
				`${className}.associate = function() {`,
				`${astr}`,
				'	};\n'
			].join('\n');
		}
		// console.log(indexesStr);
		// console.log(flist);
		// console.log(associate);
		const modeDoc = [
			"'use strict'",
			'module.exports = app => {',
			'	const DataTypes = app.Sequelize;',
			`	const ${className} = app.model.define('${tableName}', {`,
			`${flist}`,
			'	},{',
			`		${indexesStr}`,
			`		paranoid: ${modInfo.paranoid},`,
			'	});',
			`	${associateStr}`,
			`	//${className}.sync({ alter: true });`,
			`	return ${className};`,
			'};'
		].join('\n');
		// console.log(modeDoc);
		const file = path.join(this.app.baseDir, 'app', 'model', tableName + '.js');
		try {
			const data = new Uint8Array(Buffer.from(modeDoc));
			await fs.writeFile(file, data);
			// Abort the request before the promise settles.
		} catch (err) {
			// When a request is aborted - err is an AbortError
			console.error(err);
		}
	}
	// 生成全部模型
	async modelsAll() {
		const { ctx } = this;
		const rootFolder = path.join(this.app.baseDir, 'app', 'model');
		await fse.remove(rootFolder);
		const exist = fsSync.existsSync(rootFolder);
		if (!exist) {
			await fs.mkdir(rootFolder);
		}
		const model = path.join(this.app.baseDir, 'app', 'core', 'model');
		const newmodel = path.join(this.app.baseDir, 'app', 'model');
		await fse.copy(model, newmodel);
		// 获取全部模型
		const allModels = await ctx.model.SysModels.findAll();
		for (const v of allModels) {
			await this.models(v.uuid);
		}
	}
	// 生成graphql
	async graphql(uuid) {
		const { ctx } = this;
		const modInfo = await ctx.model.SysModels.findOne({ where: { uuid } });
		const className = ctx.helper._.upperFirst(ctx.helper._.camelCase(modInfo.name));
		const tableName = modInfo.name;
		// 分析关联模型
		let associateStr = ''; // 绑定resolver
		let associateFieldStr = '';// 绑定字段
		// 一对一
		const hasOne = await ctx.model.SysModelsAssociate.findAll({ where: { type: 'HasOne', parent_uuid: uuid } });
		for (const v of hasOne) {
			const child_uuid = await ctx.model.SysModels.findOne({ where: { uuid: v.child_uuid } });
			const target_key = await ctx.model.SysModelsFields.findOne({ where: { uuid: v.targetKey } });
			const foreign_key = await ctx.model.SysModelsFields.findOne({ where: { uuid: v.foreignKey } });
			const child = ctx.helper._.upperFirst(ctx.helper._.camelCase(child_uuid.name));
			const targetKey = target_key.name;
			const foreignKey = foreign_key.name;
			associateFieldStr += `		${v.alias ? v.alias : child_uuid.name}: ${child}\n`;
			associateStr += [
				`		async ${v.alias ? v.alias : child_uuid.name}(root, params, ctx) {`,
				'			const map = {};',
				`			map.where = { ${foreignKey}: root.${targetKey} };`,
				`			return await ctx.connector.${child_uuid.name}.findOne(map);`,
				'		},\n'
			].join('\n');
		}
		// 一对多
		const hasMany = await ctx.model.SysModelsAssociate.findAll({ where: { type: 'HasMany', parent_uuid: uuid } });
		for (const v of hasMany) {
			const child_uuid = await ctx.model.SysModels.findOne({ where: { uuid: v.child_uuid } });
			const target_key = await ctx.model.SysModelsFields.findOne({ where: { uuid: v.targetKey } });
			const foreign_key = await ctx.model.SysModelsFields.findOne({ where: { uuid: v.foreignKey } });
			const child = ctx.helper._.upperFirst(ctx.helper._.camelCase(child_uuid.name));
			const targetKey = target_key.name;
			const foreignKey = foreign_key.name;
			associateFieldStr += `		${v.alias ? v.alias : child_uuid.name}(order:[[String]],limit:Int,offset:Int): [${child}]\n`;
			associateStr += [
				`		async ${v.alias ? v.alias : child_uuid.name}(root, params, ctx) {`,
				'			const map = {};',
				`			map.where = { ${foreignKey}: root.${targetKey} };`,
				`			if (Object.hasOwnProperty.call(params, 'limit')) {`,
				'				map.limit = params.limit;',
				'			}',
				`			if (Object.hasOwnProperty.call(params, 'offset')) {`,
				'				map.offset = params.offset;',
				'			}',
				`			if (Object.hasOwnProperty.call(params, 'order')) {`,
				'				map.order = params.order;',
				'			}',
				`			return await ctx.connector.${child_uuid.name}.findAll(map);`,
				'		},\n'
			].join('\n');
		}
		// 所属关系
		const belongsTo = await ctx.model.SysModelsAssociate.findAll({ where: { type: 'BelongsTo', child_uuid: uuid } });
		for (const v of belongsTo) {
			const parent_uuid = await ctx.model.SysModels.findOne({ where: { uuid: v.parent_uuid } });
			const target_key = await ctx.model.SysModelsFields.findOne({ where: { uuid: v.targetKey } });
			const foreign_key = await ctx.model.SysModelsFields.findOne({ where: { uuid: v.foreignKey } });
			const parent = ctx.helper._.upperFirst(ctx.helper._.camelCase(parent_uuid.name));
			const targetKey = target_key.name;
			const foreignKey = foreign_key.name;
			associateFieldStr += `		${v.alias ? v.alias : parent_uuid.name}: ${parent}\n`;
			associateStr += [
				`		async ${v.alias ? v.alias : parent_uuid.name}(root, params, ctx) {`,
				'			const map = {};',
				`			map.where = { ${targetKey}: root.${foreignKey} };`,
				`			return await ctx.connector.${parent_uuid.name}.findOne(map);`,
				'		},\n'
			].join('\n');
		}
		// 多对多
		const belongsToMany = await ctx.model.SysModelsAssociate.findAll({ where: { type: 'BelongsToMany', parent_uuid: uuid } });
		for (const v of belongsToMany) {
			const through_uuid = await ctx.model.SysModels.findOne({ where: { uuid: v.through_uuid } });
			const target_key = await ctx.model.SysModelsFields.findOne({ where: { uuid: v.targetKey } });
			const through_key = await ctx.model.SysModelsFields.findOne({ where: { uuid: v.throughKey } });
			const through = ctx.helper._.upperFirst(ctx.helper._.camelCase(through_uuid.name));
			const targetKey = target_key.name;
			const throughKey = through_key.name;
			associateFieldStr += `		${v.alias ? v.alias : through_uuid.name}(order:[[String]],limit:Int,offset:Int): [${through}]\n`;
			associateStr += [
				`		async ${v.alias ? v.alias : through_uuid.name}(root, params, ctx) {`,
				'			const map = {};',
				`			map.where = { ${throughKey}: root.${targetKey} };`,
				`			if (Object.hasOwnProperty.call(params, 'limit')) {`,
				'				map.limit = params.limit;',
				'			}',
				`			if (Object.hasOwnProperty.call(params, 'offset')) {`,
				'				map.offset = params.offset;',
				'			}',
				`			if (Object.hasOwnProperty.call(params, 'order')) {`,
				'				map.order = params.order;',
				'			}',
				`			return await ctx.connector.${through_uuid.name}.findAll(map);`,
				'		},\n'
			].join('\n');
		}
		const throughs = await ctx.model.SysModelsAssociate.findAll({ where: { type: 'BelongsToMany', through_uuid: uuid } });
		for (const v of throughs) {
			const parent_uuid = await ctx.model.SysModels.findOne({ where: { uuid: v.parent_uuid } });
			const target_key = await ctx.model.SysModelsFields.findOne({ where: { uuid: v.targetKey } });
			const through_key = await ctx.model.SysModelsFields.findOne({ where: { uuid: v.throughKey } });
			const parent = ctx.helper._.upperFirst(ctx.helper._.camelCase(parent_uuid.name));
			const targetKey = target_key.name;
			const throughKey = through_key.name;
			associateFieldStr += `		${v.alias ? v.alias : parent_uuid.name}: ${parent}\n`;
			associateStr += [
				`		async ${v.alias ? v.alias : parent_uuid.name}(root, params, ctx) {`,
				'			const map = {};',
				`			map.where = { ${targetKey}: root.${throughKey} };`,
				`			return await ctx.connector.${parent_uuid.name}.findOne(map);`,
				'		},\n',
			].join('\n');
		}
		// console.log(associateFieldStr);
		// console.log(associateStr);

		// 生成 schema
		const fieldList = await ctx.model.SysModelsFields.findAll({ where: { models_uuid: uuid }, order: [['sort', 'ASC']] });
		let fieldListStr = '';
		for (const v of fieldList) {
			let type;
			if (v.primaryKey) {
				type = 'ID';
			} else if (v.type === 'BOOLEAN') {
				type = 'Boolean';
			} else if (v.type === 'INTEGER' || v.type === 'BIGINT') {
				type = 'Int';
			} else if (v.type === 'FLOAT' || v.type === 'DOUBLE' || v.type === 'DECIMAL') {
				type = 'Float';
			} else if (v.type === 'STRING' || v.type === 'TEXT' || v.type === 'UUID') {
				type = 'String';
			} else if (v.type === 'JSON') {
				type = 'JSON';
			}  else if (v.type === 'DATE' || v.type === 'DATEONLY') {
				type = 'Date';
			} else if (v.type === 'ENUM') {
				type = 'String';
			}
			fieldListStr += `		${v.name}:${type}\n`;
		}
		// type
		const tableType = [
			`type ${className} {`,
			`${fieldListStr}`,
			`${associateFieldStr}`,
			'	}\n'
		].join('\n');
		// input where
		const whereList = await ctx.model.SysModelsFields.findAll({ where: { models_uuid: uuid, where: true }, order: [['sort', 'ASC']] });
		let whereStr = '';
		let wherefs = '';
		let wfinput = '';
		for (const v of whereList) {
			let type;
			if (v.primaryKey) {
				type = 'ID';
			} else if (v.type === 'BOOLEAN') {
				type = 'Boolean';
			} else if (v.type === 'INTEGER' || v.type === 'BIGINT') {
				type = 'Int';
			} else if (v.type === 'FLOAT' || v.type === 'DOUBLE' || v.type === 'DECIMAL') {
				type = 'Float';
			} else if (v.type === 'STRING' || v.type === 'TEXT' || v.type === 'UUID') {
				type = 'String';
			} else if (v.type === 'JSON') {
				type = 'JSON';
			} else if (v.type === 'DATE' || v.type === 'DATEONLY') {
				type = 'Date';
			} else if (v.type === 'ENUM') {
				type = 'String';
			}
			wfinput += [
				`	input Where${className}_${v.name} {`,
				`		op_eq: ${type}`,
				`		op_ne: ${type}`,
				`		op_or: [${type}]`,
				`		op_gt: ${type}`,
				`		op_gte: ${type}`,
				`		op_lt: ${type}`,
				`		op_lte: ${type}`,
				`		op_between: [${type}]`,
				`		op_notBetween: [${type}]`,
				`		op_in: [${type}]`,
				`		op_notIn: [${type}]`,
				`		op_like: String`,
				`		op_notLike: String`,
				`		op_startsWith: String`,
				`		op_endsWith: String`,
				`		op_substring: String`,
				'	}\n'
			].join('\n');
			wherefs += `		${v.name}:Where${className}_${v.name}\n`;
			whereStr += `	${v.name}: WhereField${className}\n`;
		}
		// console.log(whereStr);
		const whereInput = [
			'',
			`${wfinput}`,
			`	input WhereField${className}{`,
			`${wherefs}`,
			'	}',
			'',
			`	input Where${className} {`,
			`${wherefs}`,
			`		op_and: [WhereField${className}]`,
			`		op_or: [WhereField${className}]`,
			`		op_not: [WhereField${className}]`,
			'	}\n'
		].join('\n');
		
		// inpt add
		const addList = await ctx.model.SysModelsFields.findAll({ where: { models_uuid: uuid, add: { [Op.eq]: true } }, order: [['sort', 'ASC']] });
		let addStr = '';
		for (const v of addList) {
			let type;
			if (v.primaryKey) {
				type = 'ID';
			} else if (v.type === 'BOOLEAN') {
				type = 'Boolean';
			} else if (v.type === 'INTEGER' || v.type === 'BIGINT') {
				type = 'Int';
			} else if (v.type === 'FLOAT' || v.type === 'DOUBLE' || v.type === 'DECIMAL') {
				type = 'Float';
			} else if (v.type === 'STRING' || v.type === 'TEXT' || v.type === 'UUID') {
				type = 'String';
			} else if (v.type === 'JSON') {
				type = 'JSON';
			} else if (v.type === 'DATE' || v.type === 'DATEONLY') {
				type = 'Date';
			} else if (v.type === 'ENUM') {
				type = 'String';
			}
			const tt = !v.allowNull ? type : `${type}!`;
			addStr += `		${v.name}: ${tt}\n`;
		}
		if (!addStr) return false;
        const addInput = [
            '',
            `	input Add${className} {`,
            `${addStr}`,
            '	}\n'
        ].join('\n');
		
		// inpt edit
		const editList = await ctx.model.SysModelsFields.findAll({ where: { models_uuid: uuid, edit: { [Op.eq]: true } }, order: [['sort', 'ASC']] });
		let editStr = '';
		for (const v of editList) {
			let type;
			if (v.primaryKey) {
				type = 'ID';
			} else if (v.type === 'BOOLEAN') {
				type = 'Boolean';
			} else if (v.type === 'INTEGER' || v.type === 'BIGINT') {
				type = 'Int';
			} else if (v.type === 'FLOAT' || v.type === 'DOUBLE' || v.type === 'DECIMAL') {
				type = 'Float';
			} else if (v.type === 'STRING' || v.type === 'TEXT' || v.type === 'UUID') {
				type = 'String';
			} else if (v.type === 'JSON') {
				type = 'JSON';
			} else if (v.type === 'DATE' || v.type === 'DATEONLY') {
				type = 'Date';
			} else if (v.type === 'ENUM') {
				type = 'String';
			}
			editStr += `		${v.name}: ${type}\n`;
		}
		if (!editStr) return false;
		const editInput = [
			'',
			`	input Edit${className} {`,
			`${editStr}`,
			'	}\n'
		].join('\n');
		
		const schema = [
			'',
			`	${tableType}`,
			`${whereInput}`,
			`${addInput}`,
			`${editInput}`,
			`	type Count${className} {`,
			'		count: Int',
			`		rows: [${className}]`,
			'	}',
			`	type ResDel${className} {`,
			'		count: Int',
			'	}',
			`	type ResEdit${className} {`,
			'		ids: [Int]',
			'	}\n',
		].join('\n');
		// console.log(schema);

		// 生成 connector
		const connector = [
			"'use strict';",
			`class ${className}Connector {`,
			' 	constructor(ctx) {',
			'		this.ctx = ctx;',
			`		this.model = ctx.app.model.${className};`,
			'	}',
			'	async findAll(body) {',
			'		const map = {};',
			`		if (Object.hasOwnProperty.call(body, 'limit')) {`,
			`			map.limit = body.limit;`,
			'		}',
			`		if (Object.hasOwnProperty.call(body, 'offset')) {`,
			`			map.offset = body.offset;`,
			'		}',
			`		// 排序`,
			`		if (body.order && !this.ctx.helper._.isEmpty(this.ctx.helper._.compact(body.order[0]))) {`,
			`			map.order = body.order;`,
			'		}',
			`		map.where = body.where;`,
			'		const res = await this.model.findAll(map);',
			'		return res;',
			'	}',
			'	async findByPk(body) {',
			'		const res = await this.model.findByPk(body.id);',
			'		return res;',
			'	}',
			'	async findOne(body) {',
			'		const map = {};',
			'		map.where = body.where;',
			'		const res = await this.model.findOne(map);',
			'		return res;',
			'	}',
			'	async findAndCountAll(body) {',
			'		const map = {};',
			'		map.limit = body.limit;',
			'		map.offset = body.offset;',
			`		if (body.order && !this.ctx.helper._.isEmpty(this.ctx.helper._.compact(body.order[0]))) {`,
			'			map.order = body.order;',
			'		}',
			'		map.where = body.where;',
			'		const res = await this.model.findAndCountAll(map);',
			'		return res;',
			'	}',
			'	async create(body) {',
			'		const res = await this.model.create(body.data);',
			'		return res;',
			'	}',
			'	async destroy(body) {',
			'		const map = {};',
			`		map.where = body.where;`,
			'		const res = await this.model.destroy(map);',
			`		return { count: res };`,
			'	}',
			'	async update(body) {',
			'		const map = {};',
			'		map.where = body.where;',
			'		const res = await this.model.update(body.data, map);',
			`		return { ids: res };`,
			'	}',
			'}',
			`module.exports = ${className}Connector;`
		].join('\n');
		// console.log(connector);

		// 生成 resolver
		const assoc = associateStr ? `${className}: {\n${associateStr}	},\n` : '';
		const resolver = [
			`'use strict';`,
			'module.exports = {',
			`	${assoc}`,
			'	Query: {',
			`		async ${className}_findAll(_root, params, ctx) {`,
			`			return await ctx.connector.${tableName}.findAll(params);`,
			'		},',
			`		async ${className}_findByPk(_root, params, ctx) {`,
			`			return await ctx.connector.${tableName}.findByPk(params);`,
			'		},',
			`		async ${className}_findOne(_root, params, ctx) {`,
			`			return await ctx.connector.${tableName}.findOne(params);`,
			'		},',
			`		async ${className}_findAndCountAll(_root, params, ctx) {`,
			`			return await ctx.connector.${tableName}.findAndCountAll(params);`,
			'		},',
			'	},',
			'	Mutation: {',
			`		async ${className}_create(_root, params, ctx) {`,
			`			return await ctx.connector.${tableName}.create(params);`,
			'		},',
			`		async ${className}_destroy(_root, params, ctx) {`,
			`			return await ctx.connector.${tableName}.destroy(params);`,
			'		},',
			`		async ${className}_update(_root, params, ctx) {`,
			`			return await ctx.connector.${tableName}.update(params);`,
			'		},',
			'	},',
			'};'
		].join('\n');
		// console.log(resolver);
		// 生成目录
		const rootFolder = path.join(this.app.baseDir, 'app', 'graphql', tableName);
		const exist = fsSync.existsSync(rootFolder);
		if (!exist) {
			await fs.mkdir(rootFolder);
		}
		const schemafile = path.join(rootFolder, 'schema.graphql');
		try {
			const schemadata = new Uint8Array(Buffer.from(schema));
			await fs.writeFile(schemafile, schemadata);
			// Abort the request before the promise settles.
		} catch (err) {
			// When a request is aborted - err is an AbortError
			console.error(err);
		}
		const connectorfile = path.join(rootFolder, 'connector.js');
		try {
			const connectordata = new Uint8Array(Buffer.from(connector));
			await fs.writeFile(connectorfile, connectordata);
			// Abort the request before the promise settles.
		} catch (err) {
			// When a request is aborted - err is an AbortError
			console.error(err);
		}
		const resolverfile = path.join(rootFolder, 'resolver.js');
		try {
			const resolverdata = new Uint8Array(Buffer.from(resolver));
			await fs.writeFile(resolverfile, resolverdata);
			// Abort the request before the promise settles.
		} catch (err) {
			// When a request is aborted - err is an AbortError
			console.error(err);
		}
		return true;
	}
	// 生成全部 graphql
	async graphqlAll() {
		const { ctx } = this;
		const rootFolder = path.join(this.app.baseDir, 'app', 'graphql');
		await fse.remove(rootFolder);
		const common = path.join(this.app.baseDir, 'app', 'core', 'graphql', 'common');
		const newcommon = path.join(this.app.baseDir, 'app', 'graphql', 'common');
		await fse.copy(common, newcommon);
		const exist = fsSync.existsSync(rootFolder);
		if (!exist) {
			await fs.mkdir(rootFolder);
		}

		// 获取全部模型
		const allModels = await ctx.model.SysModels.findAll();
		let query = '';
		let mutation = '';
		for (const v of allModels) {
			const ok = await this.graphql(v.uuid);
			if (ok) {
				const className = ctx.helper._.upperFirst(ctx.helper._.camelCase(v.name));
				query += [
					'',
					`	#${v.desc} findAll 方法. 它生成一个标准的 SELECT 查询,该查询将从表中检索所有条目(除非受到 where 子句的限制).`,
					`	${className}_findAll(where:Where${className},order:[[String]],limit:Int,offset:Int):[${className}]`,
					`	#${v.desc} findByPk 方法使用提供的主键从表中仅获得一个条目.`,
					`	${className}_findByPk(id:ID!):${className}`,
					`	#${v.desc} findOne 方法获得它找到的第一个条目(它可以满足提供的可选查询参数).`,
					`	${className}_findOne(where:Where${className}):${className}`,
					`	#${v.desc} findAndCountAll 方法是结合了 findAll 和 count 的便捷方法. 在处理与分页有关的查询时非常有用,在分页中,你想检索带有 limit 和 offset 的数据,但又需要知道与查询匹配的记录总数.`,
					`	${className}_findAndCountAll(where:Where${className},order:[[String]],limit:Int!,offset:Int!):Count${className}`,
					''
				].join('\n');
				mutation += [
					'',
					`	#${v.desc} 添加`,
					`	${className}_create(data:Add${className}):${className}`,
					`	#${v.desc} 删除`,
					`	${className}_destroy(where:Where${className}!):ResDel${className}`,
					`	#${v.desc} 更新`,
					`	${className}_update(data:Edit${className}!,where:Where${className}!):ResEdit${className}`,
					''
				].join('\n');
			}
		}
		const queryStr = [
			'type Query {',
			`${query}`,
			'}'
		].join('\n');
		const mutationStr = [
			'type Mutation {',
			`${mutation}`,
			'}'
		].join('\n');
		// 生成query和mutation
		const querypath = path.join(this.app.baseDir, 'app', 'graphql', 'query');
		const existquerypath = fsSync.existsSync(querypath);
		if (!existquerypath) {
			await fs.mkdir(querypath);
		}
		const mutationpath = path.join(this.app.baseDir, 'app', 'graphql', 'mutation');
		const existmutationpath = fsSync.existsSync(mutationpath);
		if (!existmutationpath) {
			await fs.mkdir(mutationpath);
		}
		const queryfile = path.join(querypath, 'schema.graphql');
		try {
			const querydata = new Uint8Array(Buffer.from(queryStr));
			await fs.writeFile(queryfile, querydata);
			// Abort the request before the promise settles.
		} catch (err) {
			// When a request is aborted - err is an AbortError
			console.error(err);
		}
		const mutationfile = path.join(mutationpath, 'schema.graphql');
		try {
			const mutationdata = new Uint8Array(Buffer.from(mutationStr));
			await fs.writeFile(mutationfile, mutationdata);
			// Abort the request before the promise settles.
		} catch (err) {
			// When a request is aborted - err is an AbortError
			console.error(err);
		}
	}
	// 生成路由
	async routes() {
		const { helper } = this.ctx;
		const rl = await this.ctx.model.SysRoutes.findAll({
			include: [{ model: this.ctx.model.SysRoutesClassify }],
			order: [['app', 'ASC'], ['id', 'ASC']],
            // order: [['id', 'ASC']],
			where: { admin: true }
		});
		// console.log(JSON.stringify(rl, null, 2));
		let item = '';
		for (const v of rl) {
			let middleware = '';
			if (v.sys_routes_classify.middleware && v.middleware) {
				middleware = `${v.sys_routes_classify.middleware},${v.middleware}`;
			} else if (v.sys_routes_classify.middleware) {
				middleware = `${v.sys_routes_classify.middleware}`;
			} else if (v.middleware) {
				middleware = `${v.middleware}`;
			}
			const ignoreMiddleware = v.ignoreMiddleware ? v.ignoreMiddleware.split(',') : [];
			// console.log(middleware.split(','));
			// console.log([ ...ignoreMiddleware, '' ]);
			const mw = helper._.difference(middleware.split(','), [...ignoreMiddleware, '']);
			// console.log(cw._.uniq(mw));
			const marr = [];
			for (const m of helper._.uniq(mw)) {
				if (m) {
					marr.push(`app.middleware.${m}()`);
				}

			}
			// console.log(marr.join(','));
			const mstr = helper._.isEmpty(marr.join(', ')) ? ', ' : `, ${marr.join(', ')}, `;
			let controller;
			if (v.verb === 'resources') {
				controller = `'${v.controller}'`;
			} else if (v.verb === 'redirect') {
				controller = 302;
			} else {
				controller = `'${v.controller}.${v.action}'`;
			}
			item += `	app.router.${v.verb}('${v.name}', '${v.path}'${mstr}${controller});\n`;
		}
		const routerData = [
			`'use strict';`,
			'module.exports = app => {',
			`${item}`,
			'};'
		].join('\n');
		const appDir = path.join(this.app.baseDir, 'app', 'router');
		const fileName = 'cw_router.js';
		const file = path.join(appDir, fileName);
		const exist = fsSync.existsSync(appDir);
		if (!exist) {
			await fs.mkdir(appDir);
		}
		try {
			const data = new Uint8Array(Buffer.from(routerData));
			await fs.writeFile(file, data);
			// Abort the request before the promise settles.
		} catch (err) {
			// When a request is aborted - err is an AbortError
			console.error(err);
		}
	}
	// 生成页面
	async pages(data) {
		if (data.linkType === 'schemaApi' && !data.admin && !this.ctx.helper._.isEmpty(data.link)) {
			const ff = path.join(this.app.baseDir, 'app', data.link);
            // console.log(ff);
            const exist = fsSync.existsSync(ff);
            // console.log(exist);
            if (!exist) {
                const mulu = path.join(this.app.baseDir, 'app', path.dirname(data.link));
                this.ctx.helper.mkdirsSync(mulu);
                const sdata = { type: 'page', title: data.name, body: [{ type: 'tpl', tpl: '请编辑您的页面' }] };
                try {
                    const schemaData = new Uint8Array(Buffer.from(JSON.stringify(sdata)));
                    await fs.writeFile(ff, schemaData);
                    // Abort the request before the promise settles.
                } catch (err) {
                    // When a request is aborted - err is an AbortError
                    console.error(err);
                }
            }
		}
	}
    // 根据字段数据生成amis配置
    amis(formInfo) {
        const body = [], fields = formInfo.fields || [];
        const sdata = { type: 'page', body, regions: ['body'], asideResizor: false, pullRefresh: { "disabled": true } };
        if (fields.length == 0) {
            body.push({ type: 'tpl', tpl: '您的页面没有内容哟~' });
        } else {
            const form = {
                type: 'form', id: 'form_' + formInfo.id, title: formInfo.title, mode: "flex", labelAlign: "top", dsType: "api", feat: "Insert", resetAfterSubmit: false,
                body: [
                    { type: 'hidden', name: 'presets_info.form_id', value: formInfo.id }
                ],
                actions: [
                    {
                        type: "button",
                        label: "提交",
                        onEvent: {
                            click: {
                                actions: [
                                    {
                                        actionType: "custom",
                                        script: "if (!checkCanSubmit()) {\n  event.setData({ ...event.data, canSubmit: false })\n} else {\n  event.setData({ ...event.data, canSubmit: true })\n}\n"
                                    },
                                    {
                                        actionType: "submit",
                                        expression: "${event.data.canSubmit}",
                                        componentId: 'form_' + formInfo.id
                                    }
                                ]
                            }
                        },
                        level: "primary"
                    }
                ],
                api: {
                    url: "/form/submit",
                    method: "post",
                    requestAdaptor: "",
                    adaptor: "",
                    messages: { success: '' }
                },
                onEvent: {
                    submitSucc: {
                        weight: 0,
                        actions: [
                            {
                                dialog: {
                                    body: [
                                        {
                                            tpl: "提交成功，请注意不要重复提交数据哟~",
                                            type: "tpl",
                                            wrapperComponent: ""
                                        }
                                    ],
                                    type: "dialog",
                                    title: "提示",
                                    actions: [
                                        {
                                            type: "button",
                                            label: "确定",
                                            primary: true,
                                            actionType: "confirm"
                                        }
                                    ],
                                    actionType: "confirmDialog",
                                    editorSetting: {
                                        displayName: "提交成功提示框"
                                    },
                                    showCloseButton: true
                                },
                                actionType: "confirmDialog",
                                ignoreError: false
                            }
                        ]
                    }
                },
                debug: false
            };
            body.push(form);
            for (const field of fields) {
                const formItem = { required: field.required, name: field.name, id: field.name, label: field.label };
                const moreItems = [];
                switch (field.type) {
                    case 'number':
                        {
                            formItem.type = 'input-number';
                            formItem.step = 1;
                            formItem.keyboard = true;
                            const max = parseInt(field.max), min = parseInt(field.min), precision = parseInt(field.precision);
                            if (!isNaN(max)) {
                                formItem.max = max;
                            }
                            if (!isNaN(min)) {
                                formItem.min = min;
                            }
                            if (!isNaN(precision) && precision > 0) {
                                formItem.precision = precision;
                            }
                            break;
                        }
                    case 'string':
                        {
                            const max = parseInt(field.max), min = parseInt(field.min);
                            if (!isNaN(max)) {
                                if (max > 50) {
                                    formItem.type = 'textarea';
                                    formItem.trimContents = true;
                                    formItem.minRows = 1;
                                    formItem.maxRows = 5;
                                } else {
                                    formItem.type = 'input-text';
                                }
                                formItem.maxLength = max;
                                formItem.validations = formItem.validations || {};
                                formItem.validations.maxLength = max;
                            } else {
                                formItem.type = 'input-text'
                            }
                            if (!isNaN(min)) {
                                formItem.validations = formItem.validations || {};
                                formItem.validations.minLength = min;
                            }
                            break;
                        }
                    case 'boolean':
                        formItem.type = 'checkbox';
                        formItem.option = field.label;
                        formItem.value = false;
                        delete formItem.label;
                        break;
                    case 'mobile':
                        formItem.type = 'input-text';
                        formItem.maxLength = 11;
                        formItem.validations = { maxLength: 11, minLength: 11, isPhoneNumber: true };
                        if (field.verification) {
                            formItem.addOn = {
                                label: "发送验证码",
                                type: "button",
                                countDown: 60,
                                countDownTpl: "${timeLeft} 秒后重发",
                                actionType: "ajax",
                                api: {
                                    url: "/mc/sendSms",
                                    method: "post",
                                    requestAdaptor: "",
                                    adaptor: "",
                                    messages: {},
                                    data: { mobile: '${' + field.name + '}' }
                                }
                            }
                            const smsCodeFormItem = { type: 'input-verification-code', required: true, name: field.name + '_code', id: field.name + '_code', label: '短信验证码' };
                            moreItems.push(smsCodeFormItem);
                        }
                        break;
                    case 'email':
                        formItem.type = 'input-email';
                        break;
                    case 'url':
                        formItem.type = 'input-url';
                        break;
                    case 'idCard':
                        formItem.type = 'input-text';
                        formItem.maxLength = 18;
                        formItem.validations = { isId: true };
                        break;
                    case 'date':
                        formItem.type = 'input-date';
                        formItem.valueFormat = "YYYY-MM-DD";
                        formItem.displayFormat = "YYYY-MM-DD";
                        break;
                    case 'dateTime':
                        formItem.type = 'input-datetime';
                        formItem.valueFormat = "YYYY-MM-DD HH:mm:ss";
                        formItem.displayFormat = "YYYY-MM-DD HH:mm:ss";
                        break;
                    case 'upload':
                        {
                            formItem.type = 'input-file';
                            formItem.inline = true;
                            formItem.proxy = true;
                            formItem.autoUpload = true;
                            formItem.uploadType = 'fileReceptor';
                            formItem.accept = '';
                            formItem.btnLabel = '点击上传';
                            formItem.useChunk = false;
                            formItem.drag = true;
                            formItem.asBlob = false;
                            formItem.asBase64 = false;
                            formItem.formType = 'asBlob';
                            formItem.maxSize = 10485760;
                            formItem.receiver = {
                                url: '/upload/mcToken',
                                method: "post",
                                requestAdaptor: "",
                                adaptor: "",
                                messages: {},
                                data: { "&": "$$", remark: JSON.stringify({ from: 'form', form_id: formInfo.id }) }
                            }
                            if (formInfo.config.login_type != 2) {
                                formItem.receiver.data.open = 1;
                            }
                            formItem.multiple = true;
                            formItem.joinValues = false;
                            formItem.extractValue = true;
                            const max = parseInt(field.max), min = parseInt(field.min)
                            if (!isNaN(max)) {
                                formItem.maxLength = max;
                            }
                            if (!isNaN(min)) {
                                formItem.minLength = min;
                                formItem.validations = {
                                    minLength: min
                                }
                            }
                            break;
                        }
                    case 'image':
                        {
                            formItem.type = 'input-image';
                            formItem.proxy = true;
                            formItem.autoUpload = true;
                            formItem.uploadType = 'fileReceptor';
                            formItem.imageClassName = 'r w-full';
                            formItem.accept = '.jpeg, .jpg, .png, .gif';
                            formItem.bos = 'default';
                            formItem.limit = true;
                            formItem.maxSize = 10485760;
                            formItem.receiver = {
                                url: '/upload/mcToken',
                                method: "post",
                                requestAdaptor: "",
                                adaptor: "",
                                messages: {},
                                data: { "&": "$$", remark: JSON.stringify({ from: 'form', form_id: formInfo.id }) }
                            }
                            if (formInfo.config.login_type != 2) {
                                formItem.receiver.data.open = 1;
                            }
                            formItem.multiple = true;
                            formItem.joinValues = false;
                            formItem.extractValue = true;
                            const max = parseInt(field.max), min = parseInt(field.min)
                            if (!isNaN(max)) {
                                formItem.maxLength = max;
                            }
                            if (!isNaN(min)) {
                                formItem.minLength = min;
                                formItem.validations = {
                                    minLength: min
                                }
                            }
                            break;
                        }
                    case 'radios':
                        formItem.type = 'radios';
                        formItem.inline = false;
                        formItem.options = field.options;
                        break;
                    case 'selectS':
                        formItem.type = 'select';
                        formItem.multiple = false;
                        formItem.options = field.options;
                        break;
                    case 'checkboxes':
                        formItem.type = 'checkboxes';
                        formItem.multiple = true;
                        formItem.checkAll = false;
                        formItem.joinValues = false;
                        formItem.extractValue = true;
                        formItem.inline = false;
                        formItem.options = field.options;
                        break;
                    case 'selectM':
                        formItem.type = 'select';
                        formItem.multiple = true;
                        formItem.checkAll = true;
                        formItem.defaultCheckAll = false;
                        formItem.checkAllLabel = '全选';
                        formItem.joinValues = false;
                        formItem.extractValue = true;
                        formItem.options = field.options;
                        break;
                    case 'editor':
                        formItem.type = 'input-rich-text';
                        /* tinymce
                        formItem.vendor = 'tinymce';
                        formItem.options = {
                            plugins: "",
                            toolbar: "undo redo bold italic alignleft aligncenter alignright alignjustify indent2em removeformat underline strikethrough h1 h2 h3 h4 h5 h6 forecolor",
                            menubar: false
                        }
                        //*/

                        //* froala
                        formItem.vendor = 'froala';
                        formItem.options = {
                            quickInsertEnabled: false,
                            charCounterCount: false,
                            toolbarButtons: ["paragraphFormat", "bold", "italic", "underline", "strikeThrough", "align", "undo", "redo"]
                        }
                        //*/
                        break;
                }
                form.body.push(formItem, ...moreItems);
            };
            if (formInfo.config.need_verification) {
                form.body.push({
                    "type": "hbox",
                    "columns": [
                        {
                            "body": [
                                {
                                    "type": "input-text",
                                    "label": "图形验证码",
                                    "name": "form_verification",
                                    "id": "form_verification",
                                    "mode": "horizontal",
                                    "labelAlign": "left",
                                    "placeholder": "请输入验证码",
                                    "required": true,
                                    "validations": {
                                        "maxLength": 4,
                                        "minLength": 4,
                                        "isAlphanumeric": true
                                    },
                                    "labelWidth": "var(--sizes-size-1)"
                                }
                            ],
                            "md": "auto",
                            "valign": "middle",
                            "width": "auto"
                        },
                        {
                            "body": [
                                {
                                    "id": "form_verification_captcha",
                                    "api": {
                                        "url": "/mc/captcha",
                                        "method": "get",
                                        "adaptor": "",
                                        "messages": {},
                                        "requestAdaptor": ""
                                    },
                                    "body": [
                                        {
                                            "id": "u:96663d332ecd",
                                            "tpl": "${captcha|raw}",
                                            "type": "tpl",
                                            "inline": true,
                                            "onEvent": {
                                                "click": {
                                                    "weight": 0,
                                                    "actions": [
                                                        {
                                                            "actionType": "reload",
                                                            "componentId": "form_verification_captcha",
                                                            "ignoreError": false
                                                        }
                                                    ]
                                                }
                                            },
                                            "wrapperComponent": ""
                                        }
                                    ],
                                    "type": "service",
                                    "dsType": "api"
                                }
                            ],
                            "valign": "middle",
                            "md": "auto",
                            "width": "auto"
                        }
                    ],
                    "row": null,
                    "gap": "none",
                    "valign": "middle"
                })
            } 
        }
        return sdata;
	}
    amisColumns(formInfo) {
        const columns = [
            {
                "name": "id",
                "label": "ID",
                "type": "text",
                "id": "u:9c15268ddfce",
                "placeholder": "-",
                "sortable": true,
                "searchable": {
                    "type": "group",
                    "body": [
                        {
                            "type": "input-number",
                            "name": "id",
                            "label": "ID"
                        },
                        {
                            "type": "input-text",
                            "name": "keyword",
                            "label": "关键词"
                        }
                    ]
                }
            },
            {
                "type": "date",
                "label": "提交时间",
                "name": "createdAt",
                "id": "u:d769d2094a4e",
                "placeholder": "-",
                "sortable": true,
                "format": "YYYY-MM-DD HH:mm:ss"
            },
            {
                "type": "text",
                "label": formInfo.config.login_type == 1? "用户微信openid" : "用户uuid",
                "name": "member_uuid",
                "id": "u:86cd40fc3e0f",
                "placeholder": "-",
                "copyable": true,
                "searchable": true
            },
            {
                "type": "text",
                "label": formInfo.config.login_type == 1? "用户微信昵称" : "用户名",
                "name": "member_name",
                "id": "u:f88f474d4901",
                "placeholder": "-",
                "copyable": true,
                "searchable": true
            },
            {
                "type": "text",
                "label": "用户ip",
                "name": "ip",
                "id": "u:b16cbf475ed3",
                "placeholder": "-",
                "copyable": true,
                "searchable": true
            },
            {
                "type": "mapping",
                "label": "状态",
                "name": "status",
                "id": "u:a39720f4f8d1",
                "map": {
                    "0": "<span class='label label-default'>未审核</span>",
                    "1": "<span class='label label-info'>审核中</span>",
                    "2": "<span class='label label-success'>审核通过</span>",
                    "3": "<span class='label label-danger'>审核失败</span>"
                },
                "searchable": {
                    "type": "select",
                    "options": [
                        {
                            "label": "未审核",
                            "value": 0
                        },
                        {
                            "label": "审核中",
                            "value": 1
                        },
                        {
                            "label": "审核通过",
                            "value": 2
                        },
                        {
                            "label": "审核失败",
                            "value": 3
                        }
                    ]
                },
                "quickEdit": {
                    "type": "select",
                    "options": [
                        {
                            "label": "未审核",
                            "value": 0
                        },
                        {
                            "label": "审核中",
                            "value": 1
                        },
                        {
                            "label": "审核通过",
                            "value": 2
                        },
                        {
                            "label": "审核失败",
                            "value": 3
                        }
                    ],
                    "saveImmediately": {
                        "api": {
                            "method": "post",
                            "url": "/admin/form/dataEdit",
                            "data": {
                                "form_id": "${form_id}",
                                "ids": "${id}",
                                "status": "${status}"
                            }
                        }
                    },
                    "mode": "popOver"
                },
                "placeholder": "-"
            }
        ];
        const colors = ['text-primary', 'text-success', 'text-danger', 'text-red-500', 'text-green-400', 'text-purple-900', 'text-blue-900', 'text-black', 'text-secondary', 'text-warning', 'text-yellow-400'];
        const fields = formInfo.fields || [];
        for (const field of fields) {
            const column = { name: `data.${field.name}`, id: field.name, label: field.label, className: "text-primary" };
            switch (field.type) {
                case 'boolean':
                    column.type = "mapping";
                    column.map = { true: "是", false: "否" };
                    break;
                case 'url':
                    column.type = "link";
                    column.blank = true;
                    column.innerClassName = 'underline'
                    break;
                case 'upload':
                    column.type = "each";
                    column.items = {
                        type: "tpl",
                        tpl: "<p class='m-0 underline'><a href='${item}' target='_blank'>${item}</a></p>"
                    };
                    break;
                case 'image':
                    column.type = "images";
                    column.imageGallaryClassName = "app-popover :AMISCSSWrapper";
                    column.enlargeAble = true;
                    column.showToolbar = true;
                    break;
                case 'radios':
                case 'selectS':
                case 'checkboxes':
                case 'selectM':
                    column.type = "mapping";
                    column.map = {};
                    for (let i = 0; i < field.options.length; i++) {
                        const m = field.options[i];
                        column.map[m.value] = `<span class='${colors[i%colors.length]}'>${m.label}</span>`;
                    }
                    column.className = "text-primary child-block";
                    break;
                case 'editor':
                    column.type = "tpl";
                    column.copyable = true;
                    column.popOver = {
                        mode: "dialog",
                        type: "panel",
                        title: "查看详情",
                        body: [
                            {
                                type: "tpl",
                                tpl: "${data.html|raw}",
                                wrapperComponent: "",
                                inline: false
                            }
                        ],
                        actions: [],
                        affixFooter: false
                    };
                    break;
            }
            columns.push(column)
        }
        columns.push({
            "type": "operation",
            "label": "操作",
            "buttons": [
                {
                    "type": "button",
                    "label": "删除",
                    "actionType": "ajax",
                    "level": "link",
                    "className": "text-danger",
                    "confirmText": "确定要删除？",
                    "api": {
                        "method": "post",
                        "url": "/graphql",
                        "graphql": "mutation($id:ID!){FormData_destroy(where:{id:{op_eq:$id}}){count}}",
                        "requestAdaptor": "",
                        "adaptor": "",
                        "messages": {}
                    },
                    "editorSetting": {
                        "behavior": "delete"
                    },
                    "id": "u:1826f82b3b07"
                }
            ],
            "id": "u:fbd95bc4ff38"
        });
        return columns;
    }
	// 生成 contract
	async contract() {
		const { ctx } = this;
		// 获取全部模型
		const map = {};
		map.include = [{
			model: ctx.model.SysModelsFields,
		}];
		const allModels = await ctx.model.SysModels.findAll(map);
		// console.log(JSON.stringify(allModels, null, 2));
		let contract = '';
		for (const v of allModels) {
			let item = '';
			let add = '';
			let edit = '';
			for (const f of v.sys_models_fields) {
				let type = '';
				if (f.type === 'BOOLEAN') {
					type = 'boolean';
				} else if (v.type === 'INTEGER' || v.type === 'BIGINT') {
					type = 'integer';
				} else if (f.type === 'FLOAT' || f.type === 'DOUBLE' || f.type === 'DECIMAL') {
					type = 'number';
				} else if (f.type === 'STRING' || f.type === 'TEXT' || f.type === 'UUID' || f.type === 'JSON') {
					type = 'string';
				} else if (v.type === 'DATE' || v.type === 'DATEONLY') {
					type = 'string';
				} else if (v.type === 'ENUM') {
					type = 'string';
				} else {
					type = 'string';
				}
				item += `		${f.name}: { type: '${type}', description: '${f.comment}' },\n`;
				if (f.add) {
					add += `		${f.name}: { type: '${type}', description: '${f.comment}', required: ${f.allowNull} },\n`;
				}
				if (f.edit) {
					edit += `		${f.name}: { type: '${type}', description: '${f.comment}' },\n`;
				}
			}
			contract += [
				`	// ${v.desc}`,
				`	${v.name}_item: {`,
				`${item}`,
				'	},',
				`	${v.name}_add: {`,
				`${add}`,
				'	},',
				`	${v.name}_edit: {`,
				`${edit}`,
				'	},\n',
			].join('\n');
		}
		// console.log(contract);
		const file = [
			"'use strict';",
			'// 本文件由Cmswing系统生成，请勿修改！',
			'module.exports = {',
			`	${contract}`,
			'};'
		].join('\n');
		// console.log(file);
		// console.log(modeDoc);
		const filepath = path.join(this.app.baseDir, 'app', 'contract', 'models.js');
		try {
			const data = new Uint8Array(Buffer.from(file));
			await fs.writeFile(filepath, data);
			// Abort the request before the promise settles.
		} catch (err) {
			// When a request is aborted - err is an AbortError
			console.error(err);
		}
	}
}
module.exports = GenerateService;
