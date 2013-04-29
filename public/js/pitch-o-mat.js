"use strict";

var genres = JSON.parse($('[name="__genre"]')[0].value);
var concepts = JSON.parse($('[name="__concepts"]')[0].value);

function makeGenre(genre)
{
	var content = undefined;

	if (!genre)
	{
		content = '...';
	}
	else
	{
		content = '<a href="' + genre.link_out + '" target="new">' + genre.name + '</a>';
	}

	return '<span class="genre">' + content + '</span>';
}

function makeConcept(concept)
{
	var content = undefined;

	if (!concept)
	{
		content = '...';
	}
	else
	{
		content = '<a href="' + concept.link_out + '" target="new">' + concept.name + '</a>';
	}

	return '<li class="concept">' + content + '</li>';
}

function updateGenres()
{
	console.log('updateGenres');

	if (genres.length == 0)
	{
		console.log('no genres');
		$('.nogenres').css('display', 'inline');
		$('.genres').css('display', 'none');
	}
	else
	{
		console.log(genres.length + ' genres');
		$('.nogenres').css('display', 'none');
		$('.genres').css('display', 'inline');

		if (genres.length == 1)
		{
			$('.onegenre').css('display', 'inline');
			$('.twogenres').css('display', 'none');
			$('.manygenres').css('display', 'none');
		}
		else if (genres.length == 2)
		{
			$('.onegenre').css('display', 'none');
			$('.twogenres').css('display', 'inline');
			$('.manygenres').css('display', 'none');

			$('.genre_cdr').empty().append(makeGenre(genres[1]));
		}
		else
		{
			$('.onegenre').css('display', 'none');
			$('.twogenres').css('display', 'none');
			$('.manygenres').css('display', 'inline');

			if (genres.length == 3)
			{
				$('.genre_cdr').empty().append(makeGenre(genres[1]) + ' and ' + makeGenre(genres[2]));
			}
			else
			{
				$('.genre_cdr').empty();

				for (var i = 1; i < genres.length - 1; i++)
				{
					$('.genre_cdr').append(makeGenre(genres[i]));
					$('.genre_cdr').append(', ');
				}

				$('.genre_cdr').append('and ' + makeGenre(genres[genres.length - 1]));
			}
		}

		$('.genre_car').empty().append(makeGenre(genres[0]));
	}
}

function updateConcepts()
{
	console.log('updateConcepts');

	if (concepts.length == 0)
	{
		console.log('no concepts');
		$('.noconcepts').css('display', 'inherit');
		$('.concepts').css('display', 'none');
	}
	else
	{
		console.log(concepts.length + ' concepts');
		$('.noconcepts').css('display', 'none');
		$('.concepts').css('display', 'inherit');

		$('.conceptlist').empty();

		for (var i = 0; i < concepts.length; i++)
		{
			$('.conceptlist').append(makeConcept(concepts[i]));
		}
	}
}

function addGenre(afterIndex)
{
	console.log("addGenre(" + afterIndex + ")");

	genres[afterIndex + 1] = undefined;
	
	$.getJSON('/ajax/genre', function(data) {
		putGenreAt(afterIndex + 1, data);
	});
}

function addGenreLast()
{
	addGenre(genres.length - 1);
}

function addConcept(afterIndex)
{
	console.log("addConcept(" + afterIndex + ")");

	concepts[afterIndex + 1] = undefined;

	$.getJSON('/ajax/concept', function(data) {
		putConceptAt(afterIndex + 1, data);
	});
}

function addConceptLast()
{
	addConcept(concepts.length - 1);
}

function putGenreAt(index, genre)
{
	genres[index] = genre;
	updateGenres();
}

function putConceptAt(index, concept)
{
	concepts[index] = concept;
	updateConcepts();
}

updateGenres();
updateConcepts();