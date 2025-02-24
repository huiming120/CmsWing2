'use strict';
const Controller = require('../../core/base_controller');
const _  = require('lodash');

/**
* @controller 签到墙活动管理
*/
class WallAdminController extends Controller {
    /**
     * @summary 大屏页面
     * @description 大屏扫码页面
     * @router get /admin/wall/index
     * @request query int id 表单活动id
     * @response 200 baseRes desc
     */
    async index() {
        const { ctx } = this;
        try {
            ctx.validate({
                id: { type: 'int', required: true, min: 1 }
            }, ctx.query);
        } catch (error) {
            return this.notFound(JSON.stringify(error.errors[0]));
        }
        const { id } = ctx.query;
        const wallInfo = await ctx.model.Wall.findByPk(id);
        if (!wallInfo) {
            return this.notFound('活动不存在');
        }
        if (wallInfo.config.temp) {
            const templatePath = await ctx.service.cms.web.cmsTemplatePath();
            await ctx.render(`cms/${templatePath}/${wallInfo.config.temp}`, { wallInfo });
        } else {
            await ctx.render('wall/index', { wallInfo });
        }
    }
    /**
     * @summary 抽奖页面
     * @description 抽奖页面页面
     * @router get /admin/wall/lottery
     * @request query int id 表单活动id
     * @response 200 baseRes desc
     */
    async lottery() {
        const { ctx } = this;
        try {
            ctx.validate({
                id: { type: 'int', required: true, min: 1 }
            }, ctx.query);
        } catch (error) {
            return this.notFound(JSON.stringify(error.errors[0]));
        }
        const { id } = ctx.query;
        const wallInfo = await ctx.model.Wall.findByPk(id, { include: [{ model: ctx.model.WallAward, order: [['index', 'ASC']] }] });
        if (!wallInfo) {
            return this.notFound('活动不存在');
        }
        if (wallInfo.config.cj_temp) {
            const templatePath = await ctx.service.cms.web.cmsTemplatePath();
            await ctx.render(`cms/${templatePath}/${wallInfo.config.cj_temp}`, { wallInfo });
        } else {
            await ctx.render('wall/lottery', { wallInfo });
        }
    }
    /**
     * @summary 抽奖接口
     * @description 活动抽奖
     * @router post /admin/wall/lottery
     * @request body int id 表单活动id
     * @response 200 baseRes desc
     */
    async lotteryPost() {
        const { ctx } = this;
        try {
            ctx.validate({
                id: { type: 'int', required: true, min: 1 },
                award_id: { type: 'int', required: true, min: 1 },
                count: { type: 'int', required: true, min: 1 }
            }, ctx.request.body);
        } catch (error) {
            return this.fail(JSON.stringify(error.errors[0]));
        }
        let { id, award_id, count } = ctx.request.body;
        const wallInfo = await ctx.model.Wall.findByPk(id, { include: [{ model: ctx.model.WallAward, order: [['index', 'ASC']] }] });
        if (!wallInfo) {
            return this.fail('活动不存在');
        }
        let now = Date.now();
        let sTime = new Date(wallInfo.config.cj_begin_at);
        let eTime = new Date(wallInfo.config.cj_end_at)
        if (now < sTime) {
            return this.fail('抽奖未开始');
        } else if (now > eTime) {
            return this.fail('抽奖已结束');
        }
        let awardInfo, mustZjIds = [], canotZjIds = [];
        for (const award of wallInfo.wall_awards) {
            if (award.id == award_id) {
                awardInfo = award;
                if (award.config.winner_state) {
                    mustZjIds = awardInfo.config.winners;
                }
            } else {
                if (award.config.winner_state) {
                    canotZjIds.push(...award.config.winners);
                }
            }
        }
        if (!awardInfo) {
            return this.fail('活动不存在');
        }
        const qdDataList = await ctx.model.WallQdData.findAll({ where: { wall_id: id, award_id: [0, award_id] } });
        const canZJ = [], mustZJ = [], canotZJ = [], hasZJ = [], zj = [];
        for (const qd of qdDataList) {
            if (qd.award_id != 0) {
                hasZJ.push(qd);
            } else {
                if (mustZjIds.includes(qd.openid)) {
                    mustZJ.push(qd);
                } else if (canotZjIds.includes(qd.openid)) {
                    canotZJ.push(qd);
                } else {
                    canZJ.push(qd);
                }
            }
        }
        if (hasZJ.length + count > awardInfo.count) {
            return this.fail('抽奖人数超出奖品数量');
        }
        const noZjCount = canZJ.length + mustZJ.length + canotZJ.length;
        if (noZjCount < count) {
            return this.fail('参与抽奖人数不够');
        }
        if (noZjCount == count) {
            zj = [...canZJ, ...mustZJ, ...canotZJ];
        } else {
            // 取必中奖的人
            if (mustZJ.length > count) {
                zj.push(...mustZJ.splice(0, count))
                count = 0;
            } else {
                zj.push(...mustZJ);
                count -= mustZJ.length;
                mustZJ.length = 0;
            }
            // 取可以正常中奖的人
            while (count > 0 && canZJ.length > 0) {
                const index = _.random(canZJ.length - 1);
                zj.push(canZJ[index]);
                canZJ.splice(index, 1);
                count--;
            }
            // 取本轮不能中奖的人(因为前面的人数不够)
            if (count > 0) {
                zj.push(...canotZJ.splice(0, count))
            }
        }
        await ctx.model.WallQdData.update({ award_id }, { where: { id: zj.map(item => item.id) }  });
        return this.success({ zj: _.shuffle(zj), noZJ: [...canZJ, ...mustZJ, ...canotZJ] });
    }
}
module.exports = WallAdminController;