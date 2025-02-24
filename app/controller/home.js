'use strict';

const Controller = require('../core/base_controller');
class HomeController extends Controller {
	async index() {
		const { ctx } = this;
		// const q = { query: 'mutation{\n  createItem(userID:1,content:"dfsafafdsa12312"){\n    id content\n  }\n}', variables: null };
		// const res = await ctx.graphqlQuery(JSON.stringify(q));
		// await ctx.service.sys.generate.models('1796faf3-5ec8-42ee-8db9-9cf86af0fe12');
		// await ctx.service.sys.generate.graphqlAll();
		// await ctx.service.sys.generate.graphql('1796faf3-5ec8-42ee-8db9-9cf86af0fe12');
		// await ctx.service.sys.generate.modelsAll();
		// await ctx.service.sys.generate.routes();
		// 生成目录
		// const rootFolder = path.join(this.app.baseDir, 'app', 'pages', 'aaa', 'bbbbb');
		// ctx.helper.mkdirsSync(rootFolder);
		// const mulu = path.join(this.app.baseDir, 'app', path.dirname('/fdsafsda/fdsaf/fsda.js'));
		// console.log(mulu);
		// // 生成contract
		// await ctx.service.sys.generate.contract();
		// ctx.body = 'dd';
		// 下载为 package.json
		// this.ctx.downloader('./package.json');

		// 下载为 new-name.json
		// this.ctx.downloader('package.json', 'new-name.json');

		// 下载为 new-name.json, header: X-Token: 123
		// this.ctx.downloader('package.json', 'new-name.json', { 'x-token': '123' });
        
        // 缓存
        // await this.app.cache.set('test', { name: 'peng' })
        // console.log(await this.app.cache.get('test'))
        
        // 更新缓存
        // await ctx.service.sys.cache.classify();
        // await ctx.service.sys.cache.template();
        
		await ctx.render('index');
	}
}

module.exports = HomeController;
