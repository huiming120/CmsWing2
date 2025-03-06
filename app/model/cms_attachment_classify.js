'use strict'
module.exports = app => {
	const DataTypes = app.Sequelize;
	const CmsAttachmentClassify = app.model.define('cms_attachment_classify', {
		id: { type: DataTypes.INTEGER, allowNull: false, autoIncrement:true, primaryKey: true, comment: '主键' },
		createdAt: { type: DataTypes.DATE, allowNull: false, comment: '创建时间' },
		updatedAt: { type: DataTypes.DATE, allowNull: false, comment: '更新时间' },
		pid: { type: DataTypes.INTEGER, allowNull: false, defaultValue: 0, comment: '上级分类' },
		pids: { type: DataTypes.STRING, allowNull: false, defaultValue: '', comment: '父分类链,逗号分割' },
		title: { type: DataTypes.STRING(200), allowNull: false, comment: '分类名称' },

	},{
		indexes:[{"unique":false,"fields":["pid"]},{"unique":false,"fields":["pids"]}],
		paranoid: false,
	});
	
	//CmsAttachmentClassify.sync({ alter: true });
	return CmsAttachmentClassify;
};