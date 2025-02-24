'use strict'
module.exports = app => {
	const DataTypes = app.Sequelize;
	const Special = app.model.define('special', {
		id: { type: DataTypes.INTEGER.UNSIGNED, allowNull: false, autoIncrement:true, primaryKey: true, comment: '主键' },
		createdAt: { type: DataTypes.DATE, allowNull: false, comment: '创建时间' },
		updatedAt: { type: DataTypes.DATE, allowNull: false, comment: '更新时间' },
		title: { type: DataTypes.STRING(128), allowNull: false, comment: '专题标题' },
		description: { type: DataTypes.STRING(1000), defaultValue: '', comment: '描述' },
		thumb: { type: DataTypes.STRING(256), defaultValue: '', comment: '封面图' },
		banners: { type: DataTypes.JSON, comment: '轮播图' },
		sort: { type: DataTypes.INTEGER, allowNull: false, defaultValue: 0, comment: '排序(越大越靠前)' },
		status: { type: DataTypes.BOOLEAN, allowNull: false, defaultValue: false, comment: '状态(未上线前端不可见)' },
		temp: { type: DataTypes.STRING(50), defaultValue: '', comment: '模板' },

	},{
		indexes:[{"unique":false,"fields":["status"]}],
		paranoid: false,
	});
	
	//Special.sync({ alter: true });
	return Special;
};