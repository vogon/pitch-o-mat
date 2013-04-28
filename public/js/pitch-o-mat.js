"use strict";

function addGenre(afterIndex)
{
	console.log("addGenre(" + afterIndex + ")");

	var placeholder = $('<div class="genre">...</div>');
	$('.genre:eq(' + afterIndex + ')').after(placeholder);

	$.getJSON('/ajax/genre', function(data) {
		putGenreInto(placeholder, data);
	});
}

function addGenreLast()
{
	addGenre($('.genres').children().length - 1)
}

function addConcept(afterIndex)
{
	console.log("addConcept(" + afterIndex + ")");
}

function putGenreInto(dom, genre)
{
	console.log('putGenreInto(' + dom + ', ' + genre + ')')
	dom.empty().append('<a href="' + genre.link_out + '">' + genre.name + '</a>')
}

function putConceptInto(dom, concept)
{

}