'use strict'
module.exports = app => {
	const DataTypes = app.Sequelize;
	const CmsDocPicture = app.model.define('cms_doc_picture', {
		id: { type: DataTypes.INTEGER, allowNull: false, autoIncrement:true, primaryKey: true, comment: '主键' },
		createdAt: { type: DataTypes.DATE, allowNull: false, comment: '创建时间' },
		updatedAt: { type: DataTypes.DATE, allowNull: false, comment: '更新时间' },
		doc_id: { type: DataTypes.INTEGER, allowNull: false, comment: '主表id' },
		content: { type: DataTypes.JSON, allowNull: false, comment: '图片内容' },

	},{
		indexes:[{"unique":true,"fields":["doc_id"]}],
		paranoid: true,
	});
	
	//CmsDocPicture.sync({ alter: true });
	return CmsDocPicture;
};