'use strict'
module.exports = app => {
	const DataTypes = app.Sequelize;
	const WallQdData = app.model.define('wall_qd_data', {
		id: { type: DataTypes.INTEGER, allowNull: false, autoIncrement:true, primaryKey: true, comment: '主键' },
		createdAt: { type: DataTypes.DATE, allowNull: false, comment: '创建时间' },
		updatedAt: { type: DataTypes.DATE, allowNull: false, comment: '更新时间' },
		wall_id: { type: DataTypes.INTEGER, allowNull: false, comment: '签到墙活动id' },
		openid: { type: DataTypes.UUID, allowNull: false, defaultValue: DataTypes.UUIDV4, comment: '用户微信id' },
		award_id: { type: DataTypes.INTEGER.UNSIGNED, allowNull: false, defaultValue: 0, comment: '中奖奖品id(未中奖为0)' },
		data: { type: DataTypes.JSON, allowNull: false, comment: '用户数据' },

	},{
		indexes:[{"unique":true,"fields":["openid","wall_id"]},{"unique":false,"fields":["wall_id"]}],
		paranoid: false,
	});
	
	//WallQdData.sync({ alter: true });
	return WallQdData;
};