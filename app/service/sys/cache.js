'use strict';
const Service = require('egg').Service;
class cacheService extends Service {
    // 分类缓存
    async classify() {
        const classifyList = await this.ctx.model.CmsClassify.findAll({ where: { status: true }, order: [['sort', 'ASC'], ['id', 'ASC']] });
        const classifyMap = {}; 
        for (const classify of classifyList) {
            classify.dataValues.childrenIds = []
            classify.dataValues.parentIds = []
            classifyMap[classify.id] = classify;
        }
        for (const classify of classifyList) {
            if (classify.pid && classifyMap[classify.pid]) {
                classifyMap[classify.pid].dataValues.childrenIds.push(classify.id)
                classify.dataValues.parentIds.push(classify.pid);      
                let parentClassify = classifyMap[classify.pid]; 
                while (parentClassify.pid && classifyMap[parentClassify.pid]) {
                    classify.dataValues.parentIds.unshift(parentClassify.pid);
                    parentClassify = classifyMap[parentClassify.pid]; 
                }
            }
        }
        await this.app.cache.set('classifyList', classifyMap);
    }

    // 模板缓存
    async template() {
        const templateInfo = (await this.ctx.model.CmsTemplate.findOne({ where: { isu: true } })).toJSON();
        const useList = await this.ctx.model.CmsTemplateList.findAll({ where: { isu: true, template_uuid: templateInfo.uuid } });
        for (const use of useList) {
            templateInfo[use.type + '_use'] = use.name;
        }
        // templateInfo[indexUse.type + '_use'] = (await this.ctx.model.CmsTemplateList.findOne({ where: { isu: true, type: 'index', template_uuid: templateInfo.uuid } })).name;
        // const specialIndexUse = await this.ctx.model.CmsTemplateList.findOne({ where: { isu: true, type: 'special', name: 'index', template_uuid: templateInfo.uuid } });
        // templateInfo.specialIndex = specialIndexUse ? specialIndexUse.name : '';
        await this.app.cache.set('templateInfo', templateInfo)
    }
    
    // 导航缓存
    async navigation() {
        const navigationList = await this.ctx.model.SysNavigation.findAll({ where: { status: true }, order: [['sort', 'ASC'], ['id', 'ASC']] });
        const navigationMap = {};
        for (const navigationModel of navigationList) {
            const navigation = navigationModel.toJSON();
            const type = navigation.type;
            let typeNa = navigationMap[type]
            if (!typeNa) {
                typeNa = [];
                navigationMap[type] = typeNa;
            }
            typeNa.push(navigation);
        }
        for (const key in navigationMap) {
            const tree = this.ctx.helper.arr_to_tree(navigationMap[key], 0);
            await this.app.cache.set('navigation:' + key, tree)
        }
    }

    // 刷新所有
    async reloadAll() {
        await this.classify();
        await this.template();
        await this.navigation();
    }
}
module.exports = cacheService;