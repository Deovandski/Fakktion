import DS from "ember-data";

export default DS.Model.extend
({
	genre_id: DS.attr ('number'),
	user_id: DS.attr ('number'),
	fact_link: DS.attr ('string'),
	fiction_link: DS.attr ('string'),
	title: DS.attr ('string'),
	importance: DS.attr ('number'),
	soft_delete: DS.attr ('boolean'),
	soft_delete_date: DS.attr ('date'),
	hidden: DS.attr ('boolean'),
	views_count: DS.attr ('number'),
	text: DS.attr ('string'),
	comments_count: DS.attr ('number'),
	comments: DS.hasMany('comment', {async: true}),
	genre: DS.belongsTo('genre', {async: true}),
	fact_type: DS.belongsTo('fact_type', {async: true}),
	category: DS.belongsTo('category', {async: true}),
	topic: DS.belongsTo('topic', {async: true})
});
