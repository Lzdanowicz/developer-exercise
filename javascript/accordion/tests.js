$(document).ready(function(){
  module("Accordion tests");
  var len = $('h3').length;


	//Test to make sure every Header tag makes it's own div open on click. 
	test("Each paragraph becomes visible on it's header's click", function() {
		for (i=0; i<len; i++) {
			$('h3:eq(' + i + ')').trigger("click")
			ok( $('.description p:eq(' + i + ')').is(":visible") )
		}			
	});


	//Test to make sure there is always one visible description div.
	// Far from a great test, was very difficult to inplement in the scope of the function above
	setTimeout(function(){
		test("There is always only one visable paragraph description at all times", function() {
			ok( $('.description p:visible').length === 1)
		});
	}, 500)


	//Test to ensure all headers have content information within them.
	test("Paragraphs are not empty", function() {
		descriptLen = $('.description p').length 
		for (i=0; i<descriptLen; i++) {
			notOk( $('.description p:eq(' + i + ')').is[":empty"] )
		}
	});

	//Test to make sure first header element is active on page load

});
