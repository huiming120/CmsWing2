'use strict';

/** @type Egg.EggPlugin */
module.exports = {
    // had enabled by egg
    // static: {
    //   enable: true,
    // }
    watcher: {
        enable: false,
        env: ['local']
    },
    cors: {
        enable: true,
        package: 'egg-cors',
    },
    swaggerdoc: {
        enable: false,
        package: 'egg-swagger-docs',
    },
    nunjucks: {
        enable: true,
        package: 'egg-view-nunjucks',
    },
    sequelize: {
        enable: true,
        package: 'egg-sequelize',
    },
    graphql: {
        enable: true,
        package: 'egg-graphql',
    },
    downloader: {
        enable: true,
        package: 'egg-downloader',
    },
    cache: {
        enable: true,
        package: 'egg-cache',
    },
    validate: {
        enable: true,
        package: 'egg-validate'
    }
};
