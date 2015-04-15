// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .
$(function () {
    $(".gallery li").on("mouseenter mouseleave", function(e){

      /** the width and height of the current div **/
      var w = $(this).width();
      var h = $(this).height();

      /** calculate the x and y to get an angle to the center of the div from that x and y. **/
      /** gets the x value relative to the center of the DIV and "normalize" it **/
      var x = (e.pageX - this.offsetLeft - (w/2)) * ( w > h ? (h/w) : 1 );
      var y = (e.pageY - this.offsetTop  - (h/2)) * ( h > w ? (w/h) : 1 );

      /** the angle and the direction from where the mouse came in/went out clockwise (TRBL=0123);**/
      /** first calculate the angle of the point,
       add 180 deg to get rid of the negative values
        divide by 90 to get the quadrant
         add 3 and do a modulo by 4  to shift the quadrants to a proper clockwise TRBL (top/right/bottom/left) **/
         var direction = Math.round((((Math.atan2(y, x) * (180 / Math.PI)) + 180 ) / 90 ) + 3 )  % 4;



           /** check for direction **/
           switch(direction) {
              case 0:
                // direction top
                  var slideFrom = {"top":"-100%", "right":"0"};
                    var slideTo = {"top":0};

                      var imgSlide = "0, 60";
                       break;
                        case 1: //
                          // direction right
                            var slideFrom = {"top":"0", "right":"-100%"};
                              var slideTo = {"right":0};

                                var imgSlide = "-60, 0";
                                 break;
                                  case 2:
                                    // direction bottom
                                      var slideFrom = {"top":"100%", "right":"0"};
                                        var slideTo = {"top":0};

                                          var imgSlide = "0, -60";
                                            break;
                                             case 3:
                                               // direction left
                                                 var slideFrom = {"top":"0", "right":"100%"};
                                                   var slideTo = {"right":0};

                                                     var imgSlide = "60, 0";
                                                      break;
                                                      }



                                                          if( e.type === 'mouseenter' ) {

                                                                  var element = $(this);

                                                                        element.find(".info").removeClass("transform").css(slideFrom);
                                                                              element.find("img").addClass("transform").css("transform","matrix(1, 0, 0, 1,"+imgSlide+")");

                                                                                    setTimeout(function(){
                                                                                              element.find(".info").addClass("transform").css(slideTo);
                                                                                                    },1);


                                                                                                        }else {

                                                                                                                var element = $(this);

                                                                                                                      element.find(".info").addClass("transform").css(slideFrom);
                                                                                                                            element.find("img").removeClass("transform").css("transform","matrix(1, 0, 0, 1,"+imgSlide+")");

                                                                                                                                  setTimeout(function(){
                                                                                                                                            element.find("img").addClass("transform").css("transform","matrix(1, 0, 0, 1,0,0)");
                                                                                                                                                  },1);

                                                                                                                                                      }

                                                                                                                                                      });

                                                                                                                                                      });

function remove_ticket_status(link) {
  $(link).prev("input[type=hidden]").val("1");
  $(link).closest('.fields').hide();
}

function add_fields(link, association, content) {
  var new_id = new Date().getTime(); //Used to get a unique id.
  var regexp = new RegExp("new_" + association, "g");
  $(link).parent().before(content.replace(regexp, new_id));
}