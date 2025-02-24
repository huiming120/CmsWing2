'use strict'
module.exports = app => {
	const DataTypes = app.Sequelize;
	const CmsDocArticle = app.model.define('cms_doc_article', {
		id: { type: DataTypes.INTEGER, allowNull: false, autoIncrement:true, primaryKey: true, comment: '主键' },
		createdAt: { type: DataTypes.DATE, allowNull: false, comment: '创建时间' },
		updatedAt: { type: DataTypes.DATE, allowNull: false, comment: '更新时间' },
		doc_id: { type: DataTypes.INTEGER, allowNull: false, comment: '主表id' },
		content_type: { type: DataTypes.ENUM, values: ["html","amis"], allowNull: false, defaultValue: 'html', comment: '文章内容类型(html|amis)' },
		content: { type: DataTypes.TEXT, allowNull: false, comment: '文章内容' },

	},{
		indexes:[{"unique":true,"fields":["doc_id"]}],
		paranoid: true,
	});
	
	//CmsDocArticle.sync({ alter: true });
	return CmsDocArticle;
};