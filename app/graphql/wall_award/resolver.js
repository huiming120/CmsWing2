'use strict';
module.exports = {
	WallAward: {
		async wall(root, params, ctx) {
			const map = {};
			map.where = { id: root.wall_id };
			return await ctx.connector.wall.findOne(map);
		},
	},

	Query: {
		async WallAward_findAll(_root, params, ctx) {
			return await ctx.connector.wall_award.findAll(params);
		},
		async WallAward_findByPk(_root, params, ctx) {
			return await ctx.connector.wall_award.findByPk(params);
		},
		async WallAward_findOne(_root, params, ctx) {
			return await ctx.connector.wall_award.findOne(params);
		},
		async WallAward_findAndCountAll(_root, params, ctx) {
			return await ctx.connector.wall_award.findAndCountAll(params);
		},
	},
	Mutation: {
		async WallAward_create(_root, params, ctx) {
			return await ctx.connector.wall_award.create(params);
		},
		async WallAward_destroy(_root, params, ctx) {
			return await ctx.connector.wall_award.destroy(params);
		},
		async WallAward_update(_root, params, ctx) {
			return await ctx.connector.wall_award.update(params);
		},
	},
};