'use strict';
module.exports = {
	FormData: {
		async form(root, params, ctx) {
			const map = {};
			map.where = { id: root.form_id };
			return await ctx.connector.form.findOne(map);
		},
		async mc_member(root, params, ctx) {
			const map = {};
			map.where = { uuid: root.member_uuid };
			return await ctx.connector.mc_member.findOne(map);
		},
	},

	Query: {
		async FormData_findAll(_root, params, ctx) {
			return await ctx.connector.form_data.findAll(params);
		},
		async FormData_findByPk(_root, params, ctx) {
			return await ctx.connector.form_data.findByPk(params);
		},
		async FormData_findOne(_root, params, ctx) {
			return await ctx.connector.form_data.findOne(params);
		},
		async FormData_findAndCountAll(_root, params, ctx) {
			return await ctx.connector.form_data.findAndCountAll(params);
		},
	},
	Mutation: {
		async FormData_create(_root, params, ctx) {
			return await ctx.connector.form_data.create(params);
		},
		async FormData_destroy(_root, params, ctx) {
			return await ctx.connector.form_data.destroy(params);
		},
		async FormData_update(_root, params, ctx) {
			return await ctx.connector.form_data.update(params);
		},
	},
};