'use strict'
module.exports = app => {
	const DataTypes = app.Sequelize;
	const Form = app.model.define('form', {
		id: { type: DataTypes.INTEGER, allowNull: false, autoIncrement:true, primaryKey: true, comment: '主键' },
		createdAt: { type: DataTypes.DATE, allowNull: false, comment: '创建时间' },
		updatedAt: { type: DataTypes.DATE, allowNull: false, comment: '更新时间' },
		title: { type: DataTypes.STRING(200), allowNull: false, comment: '活动名字' },
		begin_at: { type: DataTypes.DATE, allowNull: false, defaultValue: DataTypes.NOW, comment: '活动开始时间' },
		end_at: { type: DataTypes.DATE, allowNull: false, defaultValue: DataTypes.NOW, comment: '活动结束时间' },
		config: { type: DataTypes.JSON, allowNull: false, comment: '活动配置' },
		fields: { type: DataTypes.JSON, allowNull: false, comment: '字段数组' },
		amis: { type: DataTypes.JSON, comment: 'amis框架页面json配置' },
		temp: { type: DataTypes.STRING(50), defaultValue: '', comment: '模板' },

	},{
		
		paranoid: false,
	});
	
	//Form.sync({ alter: true });
	return Form;
};