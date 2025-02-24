'use strict'
module.exports = app => {
	const DataTypes = app.Sequelize;
	const WallAward = app.model.define('wall_award', {
		id: { type: DataTypes.INTEGER, allowNull: false, autoIncrement:true, primaryKey: true, comment: '主键' },
		createdAt: { type: DataTypes.DATE, allowNull: false, comment: '创建时间' },
		updatedAt: { type: DataTypes.DATE, allowNull: false, comment: '更新时间' },
		wall_id: { type: DataTypes.INTEGER, allowNull: false, comment: '签到墙活动id' },
		name: { type: DataTypes.STRING(100), allowNull: false, comment: '奖品名字' },
		count: { type: DataTypes.INTEGER.UNSIGNED, allowNull: false, defaultValue: 0, comment: '奖品数量' },
		index: { type: DataTypes.INTEGER.UNSIGNED, allowNull: false, defaultValue: 1, comment: '抽奖轮次' },
		config: { type: DataTypes.JSON, allowNull: false, comment: '奖品其他配置' },

	},{
		indexes:[{"unique":false,"fields":["wall_id"]}],
		paranoid: false,
	});
	WallAward.associate = function() {
		app.model.Wall.hasMany(app.model.WallAward, {
			foreignKey: 'wall_id',
			sourceKey: 'id',
			constraints: false,

		});
		app.model.WallAward.belongsTo(app.model.Wall, {
			foreignKey: 'wall_id',
			targetKey: 'id',
			constraints: false,

		});

	};

	//WallAward.sync({ alter: true });
	return WallAward;
};