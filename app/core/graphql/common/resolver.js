const { GraphQLJSON } = require('graphql-type-json');
module.exports = {
	Date: require('./scalars/date'), // eslint-disable-line
    JSON: GraphQLJSON,
};
