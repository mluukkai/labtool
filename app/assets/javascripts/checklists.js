$(function() {

  function getScoreInitializer(scoretypes) {
    return function() {
      var scores = {};
      $.each(scoretypes, function(id, score) {
        score.id = id;
        score.min = score.min == null ? -Infinity : parseFloat(score.min);
        score.max = score.max == null ? Infinity : parseFloat(score.max);
        score.val = parseFloat(score.initial);
        score.set = function(val) {
          score.val = Math.min(score.max, Math.max(score.min, val));
        }
        score.add = function(val) {
          score.set(score.val + val);
        }

        scores[id] = score;
        if (score.varname != undefined && score.varname != "" ) {
          scores[score.varname] = score;
        }
      });
      return scores;
    };
  }

  function addTopics(checklist, topicData) {
    $.each(topicData, function(topic_id,topic) {
      var checks = {}
      $.each(topic.checks, function(check_id,check) {
        var element = $("#"+check_id);
        check.enabled = true;
        check.checked_value = parseFloat(check.value) || 0;
        check.unchecked_value = parseFloat(check.unchecked_value) || 0;
        check.checked_feedback = check.feedback || "";
        check.unchecked_feedback = check.missing_feedback || "";
        check.checked = function() {
          return element.is(":checked");
        }
        check.makevisible = function(shown) {
          element.parent().toggle(shown);
        }
        check.value = function() {
          return check.checked() ? check.checked_value : check.unchecked_value;
        }
        check.feedback = function() {
          return check.checked() ? check.checked_feedback : check.unchecked_feedback;
        }
        checks[check.varname ? check.varname : check_id] = check;
      });

      var element = $("#"+topic_id).parent();
      var feedbackContainer = element.find(".feedback");
      var scoreCounter = element.find(".scorevalue");
      var own_update_callback = topic.update_callback;
      var update_callbacks = [own_update_callback];

      topic.checks = checks;
      topic.addUpdateCallback = function(fun) {
        if (typeof(fun) == "function") {
          update_callback.push(fun);
        }
      }
      topic.init = function() {
        update_callbacks = [own_update_callback];
        topic.feedbacks = {};
        topic.score = 0;
        topic.init_callback.call(topic, checklist);
      }

      topic.update = function() {
        topic.init();
        $.each(topic.checks, function(k) {
          this.makevisible(this.enabled);
          if (!this.enabled) return;

          topic.score += this.value();
          var feedback = this.feedback();
          if (feedback) topic.feedbacks[k] = feedback;
        });

        if (topic.scale_denominator != 0) {
          topic.score = topic.score * topic.scale_numerator / topic.scale_denominator;
        }

        $.each(update_callbacks, function() {
          this.call(topic, checklist);
        });
        topic.feedback = [];
        $.each(topic.feedbacks, function() {
          if (this) topic.feedback.push(this);
        });
        topic.feedback = topic.feedback.join(" ");

        scoreCounter.text(topic.score);
        feedbackContainer.text(topic.feedback);
      }

      element.find('input[type="checkbox"]').change(function() {
        topic.update();
        checklist.update(); 
      });

      if (topic.varname) {
        checklist.topics[topic.varname] = topic;
      } else {
        checklist.topics[topic_id] = topic;
      }
    });
  }

  $.fn.autograding = function(topicData) {
    var feedbackContainer = $(this).find('.feedbacks');
    var scoreContainer  = $(this).find('.scores');
    var initScores = getScoreInitializer(topicData.scoretypes);
    var final_grade_callback = topicData.grade_callback;
    delete topicData.scoretypes;
    delete topicData.grade_callback;

    var checklist = { 
      topics: {},
      reset: function() {
        $.each(checklist.topics, function(k,q) {
          q.update();
        });
        checklist.update(); 
      },
      update: function() {
        feedbackContainer.empty();
        scoreContainer.empty();

        checklist.feedbacks = [];

        var scores = initScores();
        $.each(checklist.topics, function(k,q) {
          if (q.feedback) {
            checklist.feedbacks.push(q.feedback);
          }
          scores[q.scoretype].add(q.score);
        });
        checklist.scores = scores;
        final_grade_callback(checklist);
        $.each(checklist.feedbacks, function(k,f) {
          var f_elem = $("<div class='topicfeedback'></div>");
          f_elem.text(f);
          feedbackContainer.append(f_elem);
        });
        $.each(checklist.scores, function(k, v) {
          if (k == v.id) { //Do not repeat stuff because of varnames
            scoreContainer.append("<p>"+this.name+": "+this.val+"</p>");
          }
        });
      }
    };
    addTopics(checklist, topicData)
    
    checklist.reset();

    $(this).find('.topic button').click(function(e) {
      e.preventDefault();
      $(this).parents('.topicContainer').toggleClass("done").find('.checks, .feedback').slideToggle();
      return false;
    });



  };
}); 

