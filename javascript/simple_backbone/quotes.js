//Pages are hardcored : remember to change that


var Quote = Backbone.Model.extend({

})

var Quotes = Backbone.Collection.extend({
	model: Quote,
	url: "https://gist.githubusercontent.com/anonymous/8f61a8733ed7fa41c4ea/raw/1e90fd2741bb6310582e3822f59927eb535f6c73/quotes.json",

	parse: function(response) {
  		return response
	},

	//creates pages based on types and is called whenever data is fetched
	pagination : function(perPage, page, type) {
		page = page-1;
		var collection = this;
		if (type === "all") {
			collection = _(collection.rest(perPage*page));
			collection = _(collection.first(perPage));
		}
		if (type === 'movies') {
			collection = _(collection.where({theme: "movies"}))
			collection = collection = _(collection.rest(perPage*page));
			collection = _(collection.first(perPage));
		}
		if (type === 'games') {
			collection = _(collection.where({theme: "games"}))
			collection = collection = _(collection.rest(perPage*page));
			collection = _(collection.first(perPage));
		}   
		return collection.map( function(model) { return model.toJSON() } ); 
    },

    //assignes a collection variable to know how many objects to hold per page.
	initialize: function(){

	this.perPage = 15

	},
});

//collection view
//add smart page numbers!
var QuotesView = Backbone.View.extend({

	el: '.container',
	initialize: function() {
		_.bindAll( this, 'render' )
		this.template = _.template( $('#allQuotesTemplate').html() )
		el = $('.container')
		this.render(1, "all");
		this.currentView = "all"
		this.typeToggle();
	},

	events: {
		"click .page-links li": "pageTurn",
		"click .type-links li a": "sortType",
	},


	render: function(pageNumber, type) {
		this.$el.html(this.template({ quotes: this.collection.pagination(15, pageNumber, type) }) );
		return this
	},


	pageTurn: function(e) {
		e.preventDefault;
		var pageNumber = e.target.innerHTML
		// var currentType = 
		this.render(pageNumber, this.currentView)
		$('li.page-link').removeClass('active')
		$('li.page-link:eq(' + (pageNumber-1) + ')').addClass('active');
	},
	//this function renders view based on type link selected
	sortType: function(e) {
		if ($(e.currentTarget).attr('href') === "#movies" ) {
			this.render(1, 'movies')
			this.currentView = 'movies';
			this.typeToggle();
		}
		if ($(e.currentTarget).attr('href') === "#games" ) {
			this.render(1, 'games')
			this.currentView = 'games';
			this.typeToggle();
		}
		if ($(e.currentTarget).attr('href') === "#all" ) {
			this.render(1, 'all')
			this.currentView = 'all';
			this.typeToggle();
		}
	},
	//
	typeToggle: function() {
		if (this.currentView === "all") {
			$('.all-link').addClass('active')
		}
		if (this.currentView === "movies") {
			$('.movies-link').addClass('active')
		}
		if (this.currentView === "games") {
			$('.games-link').addClass('active')
		}
	}
})


$(document).ready(function() {

	myCollection = new Quotes();
	myCollection.fetch({
	    success : function(myCollection, response, options) {
	        myCompositeView = new QuotesView({ collection: myCollection });
	    }
	});

});