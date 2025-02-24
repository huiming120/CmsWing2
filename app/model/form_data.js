'use strict'
module.exports = app => {
	const DataTypes = app.Sequelize;
	const FormData = app.model.define('form_data', {
		id: { type: DataTypes.INTEGER, allowNull: false, autoIncrement:true, primaryKey: true, comment: '主键' },
		createdAt: { type: DataTypes.DATE, allowNull: false, comment: '创建时间' },
		updatedAt: { type: DataTypes.DATE, allowNull: false, comment: '更新时间' },
		form_id: { type: DataTypes.INTEGER, allowNull: false, comment: '所属表单id' },
		member_uuid: { type: DataTypes.UUID, allowNull: false, defaultValue: DataTypes.UUIDV4, comment: '用户关联uuid(如果表单没限制登录默认36个0)' },
		member_name: { type: DataTypes.STRING(20), defaultValue: '游客', comment: '用户名' },
		data: { type: DataTypes.JSON, allowNull: false, comment: '数据' },
		status: { type: DataTypes.INTEGER.UNSIGNED, allowNull: false, defaultValue: 0, comment: '状态(0-未审核 1-审核中 2-审核成功 3-审核失败)' },
		ip: { type: DataTypes.STRING(24), allowNull: false, comment: '提交者ip地址' },

	},{
		indexes:[{"unique":false,"fields":["form_id"]},{"unique":false,"fields":["member_uuid"]},{"unique":false,"fields":["ip"]}],
		paranoid: false,
	});
	FormData.associate = function() {
		app.model.Form.hasMany(app.model.FormData, {
			foreignKey: 'form_id',
			sourceKey: 'id',
			constraints: false,

		});
		app.model.FormData.belongsTo(app.model.Form, {
			foreignKey: 'form_id',
			targetKey: 'id',
			constraints: false,

		});
		app.model.McMember.hasMany(app.model.FormData, {
			foreignKey: 'member_uuid',
			sourceKey: 'uuid',
			constraints: false,

		});
		app.model.FormData.belongsTo(app.model.McMember, {
			foreignKey: 'member_uuid',
			targetKey: 'uuid',
			constraints: false,

		});

	};

	//FormData.sync({ alter: true });
	return FormData;
};