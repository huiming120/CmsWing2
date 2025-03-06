'use strict'
module.exports = app => {
	const DataTypes = app.Sequelize;
	const CmsAttachment = app.model.define('cms_attachment', {
		id: { type: DataTypes.INTEGER, allowNull: false, autoIncrement:true, primaryKey: true, comment: '主键' },
		createdAt: { type: DataTypes.DATE, allowNull: false, comment: '创建时间' },
		updatedAt: { type: DataTypes.DATE, allowNull: false, comment: '更新时间' },
		attachment_classify_id: { type: DataTypes.INTEGER, allowNull: false, defaultValue: 1, comment: '附件分类id' },
		name: { type: DataTypes.STRING(50), allowNull: false, comment: '文件名字' },
		description: { type: DataTypes.STRING(100), allowNull: false, comment: '附件描述' },
		path: { type: DataTypes.STRING(200), allowNull: false, comment: '文件存储地址' },
		url: { type: DataTypes.STRING(300), allowNull: false, comment: '文件网络地址' },
		compressed_url: { type: DataTypes.STRING(300), defaultValue: '', comment: '图片压缩地址' },
		size: { type: DataTypes.INTEGER.UNSIGNED, allowNull: false, comment: '文件大小(kb)' },
		mime: { type: DataTypes.STRING(150), defaultValue: '', comment: '文件类型' },
		location: { type: DataTypes.STRING(16), allowNull: false, defaultValue: 'local', comment: '文件上传类型(local、kodo、obs、oss、cos)' },
		upload_user_uuid: { type: DataTypes.UUID, comment: '上传者uuid' },
		upload_ip: { type: DataTypes.STRING(24), allowNull: false, comment: '上传者ip地址' },
		status: { type: DataTypes.BOOLEAN, defaultValue: true, comment: '状态' },
		remark: { type: DataTypes.JSON, comment: '备注信息,方便审核通过时更新相应信息{from:上传来源(admin,avatar,form),其他信息}' },

	},{
		indexes:[{"unique":false,"fields":["name"]},{"unique":false,"fields":["description"]},{"unique":false,"fields":["attachment_classify_id"]}],
		paranoid: false,
	});
	CmsAttachment.associate = function() {
		app.model.CmsAttachmentClassify.hasMany(app.model.CmsAttachment, {
			foreignKey: 'attachment_classify_id',
			sourceKey: 'id',
			constraints: false,

		});
		app.model.CmsAttachment.belongsTo(app.model.CmsAttachmentClassify, {
			foreignKey: 'attachment_classify_id',
			targetKey: 'id',
			constraints: false,

		});

	};

	//CmsAttachment.sync({ alter: true });
	return CmsAttachment;
};