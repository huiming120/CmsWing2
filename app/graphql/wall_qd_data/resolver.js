'use strict';
module.exports = {
	
	Query: {
		async WallQdData_findAll(_root, params, ctx) {
			return await ctx.connector.wall_qd_data.findAll(params);
		},
		async WallQdData_findByPk(_root, params, ctx) {
			return await ctx.connector.wall_qd_data.findByPk(params);
		},
		async WallQdData_findOne(_root, params, ctx) {
			return await ctx.connector.wall_qd_data.findOne(params);
		},
		async WallQdData_findAndCountAll(_root, params, ctx) {
			return await ctx.connector.wall_qd_data.findAndCountAll(params);
		},
	},
	Mutation: {
		async WallQdData_create(_root, params, ctx) {
			return await ctx.connector.wall_qd_data.create(params);
		},
		async WallQdData_destroy(_root, params, ctx) {
			return await ctx.connector.wall_qd_data.destroy(params);
		},
		async WallQdData_update(_root, params, ctx) {
			return await ctx.connector.wall_qd_data.update(params);
		},
	},
};