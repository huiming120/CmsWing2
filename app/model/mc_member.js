'use strict'
module.exports = app => {
	const DataTypes = app.Sequelize;
	const McMember = app.model.define('mc_member', {
		id: { type: DataTypes.INTEGER, allowNull: false, autoIncrement:true, primaryKey: true, comment: '主键' },
		createdAt: { type: DataTypes.DATE, allowNull: false, comment: '创建时间' },
		updatedAt: { type: DataTypes.DATE, allowNull: false, comment: '更新时间' },
		username: { type: DataTypes.STRING, comment: '用户名' },
		password: { type: DataTypes.STRING, comment: '密码' },
		email: { type: DataTypes.STRING, comment: '邮箱' },
		mobile: { type: DataTypes.STRING, comment: '手机' },
		state: { type: DataTypes.BOOLEAN, defaultValue: true, comment: '状态' },
		uuid: { type: DataTypes.UUID, allowNull: false, defaultValue: DataTypes.UUIDV4, comment: 'UUid' },
		third: { type: DataTypes.JSON, comment: '第三方扩展' },
		avatar: { type: DataTypes.STRING, comment: '头像' },
		sys_user_uuid: { type: DataTypes.UUID, comment: '绑定的管理员账号uuid' },

	},{
		indexes:[{"unique":true,"fields":["uuid"]},{"unique":true,"fields":["username"]},{"unique":true,"fields":["mobile"]},{"unique":true,"fields":["email"]}],
		paranoid: false,
	});
	
	//McMember.sync({ alter: true });
	return McMember;
};