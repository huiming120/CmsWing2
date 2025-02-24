const fs = require('fs-extra');
const path = require('path');
const _ = require('lodash');
const helper = require('./app/extend/helper');
class AgentBootHook {
	constructor(agent) {
		this.agent = agent;
	}
	configWillLoad() {
		// 此时 config 文件已经被读取并合并，但是还并未生效
		// 这是应用层修改配置的最后时机
		// 注意：此函数只支持同步调用
	}
    async willReady() {
        // 加载远程配置(参考于：egg-remote-config插件,因需要加密,所以不直接用插件),保存到本地文件供app.js读取,
        let data;
        try {
            data = await this.agent.model.SysConfig.findAll();
        } catch (error) {
            const { RECORDS } = await fs.readJson(path.join(this.agent.baseDir, 'app/core/initData/sys_config.json'), { throws: false });
            data = RECORDS;
        }
        const result = {};
        for (const v of data) {
            if (v.name === 'egg') {
                // for (const key in v.value) {
                //     if (Object.hasOwnProperty.call(v.value, key)) {
                //         result[key] = v.value[key];
                //     }
                // }
                _.merge(result, v.value);
            } else {
                // result[v.name] = v.value;
                _.merge(result, { [v.name]: v.value });
            }
        }
        const remoteConfigFile = this.agent.config.remoteConfigFile;
        await fs.mkdirs(path.dirname(remoteConfigFile));
        await fs.remove(remoteConfigFile);
        await fs.writeFile(remoteConfigFile, helper.cipher(JSON.stringify(result || {})));
    }
	async didReady() {
		// 所有的配置已经加载完毕
		// 可以用来加载应用自定义的文件，启动自定义的服务
		console.log('agent ready');
		/*
		const app = this.agent;
		app.model.sync({ alter: true }).then(async () => {
			const dirs = await fs.readdir(path.join(app.baseDir, 'app', '/core/initData'));
			for (const v of dirs) {
				const name = path.basename(v, '.json');
				const modename = _.upperFirst(_.camelCase(name));
				const ext = path.extname(v);
				try {
					if (ext === '.json') {
						const count = await app.model[modename].count();
						if (count === 0) {
							const data = await fs.readJson(path.join(app.baseDir, 'app', `/core/initData/${v}`));
							await app.model[modename].bulkCreate(data.RECORDS);
						}
					}
				} catch (error) {
					console.log(error);
				}
			}
		});
		//*/
	}

	async serverDidReady() {
		console.log('egg-ready on agent');
	}

    async beforeClose() {
        // 请将你的 app.beforeClose 中的代码置于此处
        this.agent.logger.info('agent close');
        // 删除远程配置导出文件
        await fs.remove(this.agent.config.remoteConfigFile);
    }
}
module.exports = AgentBootHook;