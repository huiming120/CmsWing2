'use strict';
module.exports = {
	Form: {
		async form_data(root, params, ctx) {
			const map = {};
			map.where = { form_id: root.id };
			if (Object.hasOwnProperty.call(params, 'limit')) {
				map.limit = params.limit;
			}
			if (Object.hasOwnProperty.call(params, 'offset')) {
				map.offset = params.offset;
			}
			if (Object.hasOwnProperty.call(params, 'order')) {
				map.order = params.order;
			}
			return await ctx.connector.form_data.findAll(map);
		},
	},

	Query: {
		async Form_findAll(_root, params, ctx) {
			return await ctx.connector.form.findAll(params);
		},
		async Form_findByPk(_root, params, ctx) {
			return await ctx.connector.form.findByPk(params);
		},
		async Form_findOne(_root, params, ctx) {
			return await ctx.connector.form.findOne(params);
		},
		async Form_findAndCountAll(_root, params, ctx) {
			return await ctx.connector.form.findAndCountAll(params);
		},
	},
	Mutation: {
		async Form_create(_root, params, ctx) {
			return await ctx.connector.form.create(params);
		},
		async Form_destroy(_root, params, ctx) {
			return await ctx.connector.form.destroy(params);
		},
		async Form_update(_root, params, ctx) {
			return await ctx.connector.form.update(params);
		},
	},
};