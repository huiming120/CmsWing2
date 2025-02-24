'use strict';
module.exports = {
	Wall: {
		async wall_award(root, params, ctx) {
			const map = {};
			map.where = { wall_id: root.id };
			if (Object.hasOwnProperty.call(params, 'limit')) {
				map.limit = params.limit;
			}
			if (Object.hasOwnProperty.call(params, 'offset')) {
				map.offset = params.offset;
			}
			if (Object.hasOwnProperty.call(params, 'order')) {
				map.order = params.order;
			}
			return await ctx.connector.wall_award.findAll(map);
		},
	},

	Query: {
		async Wall_findAll(_root, params, ctx) {
			return await ctx.connector.wall.findAll(params);
		},
		async Wall_findByPk(_root, params, ctx) {
			return await ctx.connector.wall.findByPk(params);
		},
		async Wall_findOne(_root, params, ctx) {
			return await ctx.connector.wall.findOne(params);
		},
		async Wall_findAndCountAll(_root, params, ctx) {
			return await ctx.connector.wall.findAndCountAll(params);
		},
	},
	Mutation: {
		async Wall_create(_root, params, ctx) {
			return await ctx.connector.wall.create(params);
		},
		async Wall_destroy(_root, params, ctx) {
			return await ctx.connector.wall.destroy(params);
		},
		async Wall_update(_root, params, ctx) {
			return await ctx.connector.wall.update(params);
		},
	},
};