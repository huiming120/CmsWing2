const fs = require('fs');
module.exports = {
    dumpConfig() {
        console.log('不导出配置文件 agent');
        const rundir = this.config.rundir;
        if (!fs.existsSync(rundir)) fs.mkdirSync(rundir);
    }
}