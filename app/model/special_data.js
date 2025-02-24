'use strict'
module.exports = app => {
	const DataTypes = app.Sequelize;
	const SpecialData = app.model.define('special_data', {
		id: { type: DataTypes.INTEGER, allowNull: false, autoIncrement:true, primaryKey: true, comment: '主键' },
		createdAt: { type: DataTypes.DATE, allowNull: false, comment: '创建时间' },
		updatedAt: { type: DataTypes.DATE, allowNull: false, comment: '更新时间' },
		special_id: { type: DataTypes.INTEGER.UNSIGNED, allowNull: false, comment: '所属专题id' },
		doc_id: { type: DataTypes.INTEGER.UNSIGNED, allowNull: false, comment: '稿件id' },
		sort: { type: DataTypes.INTEGER, allowNull: false, defaultValue: 0, comment: '排序(越大越靠前)' },

	},{
		indexes:[{"unique":true,"fields":["special_id","doc_id"]}],
		paranoid: false,
	});
	SpecialData.associate = function() {
		app.model.Special.belongsToMany(app.model.CmsDoc, {
			through: { model: app.model.SpecialData, unique: false },
			foreignKey: 'special_id',
			sourceKey: 'id',
			targetKey: 'id',
			constraints: false,

		});
		app.model.CmsDoc.belongsToMany(app.model.Special, {
			through: { model: app.model.SpecialData, unique: false },
			foreignKey: 'doc_id',
			sourceKey: 'id',
			targetKey: 'id',
			constraints: false,

		});
		app.model.CmsDoc.hasMany(app.model.SpecialData, {
			foreignKey: 'doc_id',
			sourceKey: 'id',
			constraints: false,
			as: 'special_data2'
		});
		app.model.SpecialData.belongsTo(app.model.CmsDoc, {
			foreignKey: 'doc_id',
			targetKey: 'id',
			constraints: false,
			as: 'cms_doc2'
		});

	};

	//SpecialData.sync({ alter: true });
	return SpecialData;
};