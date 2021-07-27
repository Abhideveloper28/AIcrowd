# Be sure to restart your server when you modify this file.
#
# +grant_on+ accepts:
# * Nothing (always grants)
# * A block which evaluates to boolean (recieves the object as parameter)
# * A block with a hash composed of methods to run on the target object with
#   expected values (+votes: 5+ for instance).
#
# +grant_on+ can have a +:to+ method name, which called over the target object
# should retrieve the object to badge (could be +:user+, +:self+, +:follower+,
# etc). If it's not defined merit will apply the badge to the user who
# triggered the action (:action_user by default). If it's :itself, it badges
# the created object (new user for instance).
#
# The :temporary option indicates that if the condition doesn't hold but the
# badge is granted, then it's removed. It's false by default (badges are kept
# forever).

module Merit
  class BadgeRules
    include Merit::BadgeRulesMethods

    def initialize
      # If it creates user, grant badge
      # Should be "current_user" after registration for badge to be granted.
      # Find badge by badge_id, badge_id takes presidence over badge
      # grant_on 'users#create', badge_id: 7, badge: 'just-registered', to: :itself

      # If it has 10 comments, grant commenter-10 badge
      # grant_on 'comments#create', badge: 'commenter', level: 10 do |comment|
      #   comment.user.comments.count == 10
      # end

      # If it has 5 votes, grant relevant-commenter badge
      # grant_on 'comments#vote', badge: 'relevant-commenter',
      #   to: :user do |comment|
      #
      #   comment.votes.count == 5
      # end

      # Changes his name by one wider than 4 chars (arbitrary ruby code case)
      # grant_on 'registrations#update', badge: 'autobiographer',
      #   temporary: true, model_name: 'User' do |user|
      #
      #   user.name.length > 4
      # end

      # Liked n number of challenges

      grant_on 'votes#create', badge: 'liked-5-challenge-badge', level: 1 do |vote|
        vote.participant.votes.where(votable_type: "Challenge").count == 5
      end

      grant_on 'votes#create', badge: 'liked-10-challenge-badge', level: 2 do |vote|
        vote.participant.votes.where(votable_type: "Challenge").count == 10
      end

      grant_on 'votes#create', badge: 'liked-20-challenge-badge', level: 3 do |vote|
        vote.participant.votes.where(votable_type: "Challenge").count == 20
      end

      # Followed n number of challenges

      grant_on 'follows#create', badge: 'followed-5-challenge', level: 1 do |follow|
        Follow.where(participant_id: follow.participant_id, followable_type: "Challenge").count == 5
      end

      grant_on 'follows#create', badge: 'followed-10-challenge', level: 2 do |follow|
        Follow.where(participant_id: follow.participant_id, followable_type: "Challenge").count == 10
      end

      grant_on 'follows#create', badge: 'followed-20-challenge', level: 3 do |follow|
        Follow.where(participant_id: follow.participant_id, followable_type: "Challenge").count == 20
      end

      # Participated in n number of challenges

      grant_on ['challenge_participants#create', 'challenge_participants#update'], badge: 'participated-in-5-challenge', level: 1 do |challenge_participant|
        challenge_participant.participant.challenge_participants.count == 5
      end

      grant_on ['challenge_participants#create', 'challenge_participants#update'], badge: 'participated-in-10-challenge', level: 2 do |challenge_participant|
        challenge_participant.participant.challenge_participants.count == 10
      end

      grant_on ['challenge_participants#create', 'challenge_participants#update'], badge: 'participated-in-20-challenge', level: 3 do |challenge_participant|
        challenge_participant.participant.challenge_participants.count == 20
      end

      # Badges for number of submissions

      grant_on 'submissions#create', badge: 'submitted-40-submissions', level: 1 do |submission|
        submission.participant.submissions.count == 40
      end

      grant_on 'submissions#create', badge: 'submitted-80-submissions', level: 2 do |submission|
        submission.participant.submissions.count == 80
      end

      grant_on 'submissions#create', badge: 'submitted-120-submissions', level: 3 do |submission|
        submission.participant.submissions.count == 120
      end

      # Badges for number of successful submissions

      grant_on 'submissions#create', badge: 'submitted-20-successful-submissions', level: 1 do |submission|
        submission.participant.submissions.where(grading_status_cd: 'graded').count == 20
      end

      grant_on 'submissions#create', badge: 'submitted-50-successful-submissions', level: 2 do |submission|
        submission.participant.submissions.where(grading_status_cd: 'graded').count == 50
      end

      grant_on 'submissions#create', badge: 'submitted-80-successful-submissions', level: 3 do |submission|
        submission.participant.submissions.where(grading_status_cd: 'graded').count == 80
      end

      # Badges for winning a challenge
      # Liked n number of practice problems
      # Shared n number of practice problems
      # Followed n number of practice problems
      # Participate in n number of practice problems
      # N number of successful submissions
      # Badges for consecutive days submissions
      # Badges for rank improvement
      # Badges for score improvement
      # Actively participated in one challenge, made 2 submissions and liked 2 challenges.
      # Badges for inviting users

      # Notebook Related Badges

      grant_on 'posts#create', badge: 'created-3-notebooks', level: 1 do |post|
        post.participant.posts.count == 3
      end

      grant_on 'posts#create', badge: 'created-10-notebooks', level: 2 do |post|
        post.participant.posts.count == 10
      end

      grant_on 'posts#create', badge: 'created-25-notebooks', level: 3 do |post|
        post.participant.posts.count == 25
      end

      grant_on 'posts#update', badge: 'blitz-community-winner', level: 1, to: :participant do |post|
        post.blitz_community_winner
      end

      grant_on 'posts#update', badge: 'community-explainer-winner', level: 1, to: :participant do |post|
        post.community_explainer_winner
      end

      # Notebook shared n times

      # Participant liked notebooks n number of times

      grant_on 'votes#create', badge: 'liked-10-notebooks', level: 1 do |vote|
        vote.participant.votes.where(votable_type: "Post").count == 10
      end

      grant_on 'votes#create', badge: 'liked-25-notebooks', level: 2 do |vote|
        vote.participant.votes.where(votable_type: "Challenge").count == 25
      end

      grant_on 'votes#create', badge: 'liked-40-notebooks', level: 3 do |vote|
        vote.participant.votes.where(votable_type: "Challenge").count == 40
      end

      # Participant Notebooks were liked n number of times

      grant_on 'votes#create', badge: 'notebook-liked-5', level: 1, to: :participant do |vote|
        vote.votable.is_a?(Post) && vote.votable.votes.count == 5
      end

      grant_on 'votes#create', badge: 'notebook-liked-20', level: 2, to: :participant do |vote|
        vote.votable.is_a?(Post) && vote.votable.votes.count == 20
      end

      grant_on 'votes#create', badge: 'notebook-liked-35', level: 3, to: :participant do |vote|
        vote.votable.is_a?(Post) && vote.votable.votes.count == 35
      end

      # Participant commented on a notebook n number of times
      # Participant notebooks received n number of comments
      # Subscribed n times
      # N subscribers
      # Download notebooks
      # Created one notebook, like 3 notebooks, shared 2 notebooks
      # Created n number of blitz notebooks
      #
      #
      # Created first notebook
      # Shared first notebook
      # Notebook was shared first time
      # Liked 1 notebook
      # Notebook got first like
      # Commented on 1 notebook
      # Notebook got 1 comment
      # You subscribed to your 1st notebook
      # Your notebook got 1st subscriber
      # You downloaded your 1st notebook
      # Your notebook got its 1st download
      #
      # Listing all the first time badges
      #
      #




    end
  end
end
