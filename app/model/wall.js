'use strict'
module.exports = app => {
	const DataTypes = app.Sequelize;
	const Wall = app.model.define('wall', {
		id: { type: DataTypes.INTEGER, allowNull: false, autoIncrement:true, primaryKey: true, comment: '主键' },
		createdAt: { type: DataTypes.DATE, allowNull: false, comment: '创建时间' },
		updatedAt: { type: DataTypes.DATE, allowNull: false, comment: '更新时间' },
		title: { type: DataTypes.STRING(200), allowNull: false, comment: '活动标题' },
		config: { type: DataTypes.JSON, allowNull: false, comment: '活动配置' },

	},{
		
		paranoid: false,
	});
	
	//Wall.sync({ alter: true });
	return Wall;
};