'use strict'
module.exports = app => {
	const DataTypes = app.Sequelize;
	const CmsTemplateList = app.model.define('cms_template_list', {
		id: { type: DataTypes.INTEGER, allowNull: false, autoIncrement:true, primaryKey: true, comment: '主键' },
		createdAt: { type: DataTypes.DATE, allowNull: false, comment: '创建时间' },
		updatedAt: { type: DataTypes.DATE, allowNull: false, comment: '更新时间' },
		template_uuid: { type: DataTypes.UUID, allowNull: false, comment: '模板UUID' },
		title: { type: DataTypes.STRING, allowNull: false, comment: '模板名称' },
		type: { type: DataTypes.STRING, allowNull: false, defaultValue: 'index', comment: '类型' },
		name: { type: DataTypes.STRING, allowNull: false, comment: '文件名称' },
		isd: { type: DataTypes.BOOLEAN, defaultValue: false, comment: '是否默认' },
		isu: { type: DataTypes.BOOLEAN, defaultValue: false, comment: '使用中' },
		uuid: { type: DataTypes.UUID, allowNull: false, defaultValue: DataTypes.UUIDV4, comment: 'UUID' },

	},{
		indexes:[{"unique":false,"fields":["template_uuid"]},{"unique":true,"fields":["uuid"]}],
		paranoid: false,
	});
	
	//CmsTemplateList.sync({ alter: true });
	return CmsTemplateList;
};