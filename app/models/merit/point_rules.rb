# Be sure to restart your server when you modify this file.
#
# Points are a simple integer value which are given to "meritable" resources
# according to rules in +app/models/merit/point_rules.rb+. They are given on
# actions-triggered, either to the action user or to the method (or array of
# methods) defined in the +:to+ option.
#
# 'score' method may accept a block which evaluates to boolean
# (recieves the object as parameter)

module Merit
  class PointRules
    include Merit::PointRulesMethods

    def initialize
      ### CHALLENGE BADGE POINTS

      # Shared challenge

      # Participated in n number of challenges

      score 1, :on => ['challenge_participants#create'], category: 'Participated Challenge'

      # Badges for number of submissions

      score 1, :on => 'submissions#create', category: 'Made Submission'

      # Finished in top 20 percentile
      # Finished in top 10 percentile
      # Finished in top 5 percentile
      # Shared Practice Problem

      # Participate in n number of practice problems

      score 1, :on => ['challenge_participants#create', 'challenge_participants#update'], category: 'Participated In Practice Challenge' do |challenge_participant|
        challenge_participant.challenge.practice_flag == true
      end

      # Submission Streak
      # Need to discuss this
      score 1, :on => 'submissions#create', category: 'Submission Streak' do |submission|
        submission.participant_streak_days >=
      end

      # Leaderboard Ninja
      # Improved Score
      # Participated in one challenge, made 2 submissions and liked 2 challenges.
      # Invited User
      score 1, :on => 'team_invitations/acceptances#create', category: 'Invited User', model_name: "Invitation" do |invitation|
        invitaiton.status == 'accepted'
      end


      # Notebook Related Badges

      # Create Notebook Badges

      score 1, :on => 'posts#create', category: 'Created Notebook'

      score -1, :on => 'posts#destroy', category: 'Created Notebook'

      score 1, :on => 'posts#update', category: 'Won Blitz Community Explainer', to: :participant do |post|
        post.blitz_community_winner
      end

      score 1, :on => 'posts#update', category: 'Won Challenge Community Explainer', to: :participant do |post|
        post.community_explainer_winner
      end

      # Shared Notebook
      # Notebook Was Shared

      # Participant Notebooks were liked n number of times

      score 1, :on => ['votes#create', 'votes#white_vote_create'], category: 'Notebook Was Liked', to: :participant do |vote|
        vote.votable_type == "Post"
      end

      score -1, :on => ['votes#destroy', 'votes#white_vote_destroy'], category: 'Notebook Was Liked', to: :participant do |vote|
        vote.votable_type == "Post"
      end


      # Participant commented on a notebook n number of times
      score 1, :on => ['commontator/comments#create'], category: 'Commented On Notebook', model_name: 'CommontatorThread' do |comment|
        comment.commontable_type == "Post" && CommontatorComment.where(thread_id: comment.id).count == 5
      end

      score 1, :on => ['commontator/comments#create'], category: 'Commented On Notebook', model_name: 'CommontatorThread' do |comment|
        comment.commontable_type == "Post" && CommontatorComment.where(thread_id: comment.id).count == 15
      end

      score 1, :on => ['commontator/comments#create'], category: 'Commented On Notebook', model_name: 'CommontatorThread' do |comment|
        comment.commontable_type == "Post" && CommontatorComment.where(thread_id: comment.id).count == 35
      end

      # Notebook Received Comment
      score 1, :on => ['commontator/comments#create'], category: 'Notebook Received Comment', model_name: 'CommontatorThread', to: :post_user do |comment|
        comment.commontable_type == "Post"
      end

      # Bookmarked Notebook

      score 1, :on => 'post_bookmarks#create', category: 'Bookmarked Notebook'

      score -1, :on => 'post_bookmarks#destroy', category: 'Bookmarked Notebook'

      # Notebook Received Bookmark

      score 1, :on => 'post_bookmarks#create', category: 'Notebook Was Bookmarked', to: :participant

      score -1, :on => 'post_bookmarks#destroy', category: 'Notebook Was Bookmarked', to: :participant

      # Executed Notebook
      # Notebook Was Executed
      # Created one notebook, like 3 notebooks, shared 2 notebooks
      # Created Blitz Notebook


      # INDUCTION BADGES

      # Sign Up
      score 1, :on => 'participants/registrations#create', category: 'Sign Up'

      # Created first notebook
      score 1, :on => 'posts#create', category: 'Created First Notebook' do |post|
        participant.points(category: 'Created First Notebook') == 0
      end

      # Liked 1 notebook

      score 1, :on => 'votes#create', category: 'Liked First Notebook' do |vote|
        vote.votable_type == "Post" && participant.points(category: 'Liked First Notebook') == 0
      end

      # Notebook got first like

      score 1, :on => 'votes#create', category: 'Notebook got first like', to: :participant do |vote|
        vote.votable_type == "Post" && participant.points(category: 'Notebook got first like') == 0
      end


      # Complete Bio/Profile
      score 1, :on => 'participants#update', category: 'Completed Bio-Profile' do |participant|
        participant.bio.present? && participant.points(category: 'Completed Bio-Profile') == 0
      end

      # Fill up details on country
      score 1, :on => 'participants#update', category: 'Completed Country' do |participant|
        participant.country_cd.present? && participant.points(category: 'Completed Country') == 0
      end

      # Filling up details on portfolio/links
      score 1, :on => 'participants#update', category: 'Completed Portfolio/Links' do |participant|
        participant.website.present? &&
        participant.github.present? &&
        participant.linkedin.present? &&
        participant.twitter.present? &&
        participant.bio.present? &&
        participant.points(category: 'Completed Portfolio/Links') == 0
      end

      # Followed their first Aicrew member
      score 1, :on => 'follows#create', category: 'Followed First Member' do |follow|
        follow.followable_type == "Participant" && participant.points(category: 'Followed First Member') == 0
      end


      score 1, :on => 'follows#create', category: 'Got First Follower', to: :followable do |follow|
        follow.followable_type == "Participant" && participant.points(category: 'Got First Follower') == 0
      end

      # Liked a blogpost
      score 1, :on => 'votes#create', category: 'Liked First Blog' do |vote|
        vote.votable.is_a?(Blog) && participant.points(category: 'Liked First Blog') == 0
      end

      # Logged First Feedback

      score 1, :on => 'feedbacks#create', category: 'Logged First Feedback' do |feedback|
        Feedback.where(participant_id: feedback.participant_id).count == 1
      end

      # Attended First Townhall/Workshop

      # Made their first team
      score 1, :on => 'challenges/teams#create', category: 'Created First Team' do |team|
        TeamParticipant.where(team_id: team.id).count  == 1
      end

      # Liked First Challenge
      score 1, :on => 'votes#create', category: 'Liked Challenge' do |vote|
        vote.participant.votes.where(votable_type: "Challenge").count == 1
      end

      # Shared First Challenge

      # Followed First Challenge
      score 1, :on => 'follows#create', category: 'Followed Challenge' do |follow|
        Follow.where(participant_id: follow.participant_id, followable_type: "Challenge").count == 1
      end

      # Accepted Rules

      # Participated In First Challenge
      score 1, :on => ['challenge_participants#create', 'challenge_participants#update'], category: 'Participated Challenge' do |challenge_participant|
        challenge_participant.participant.challenge_participants.count == 1
      end

      # First Submission
      score 1, :on => 'submissions#create', category: 'Made Submission' do |submission|
        submission.participant.submissions.count == 1
      end

      # First Submission With Baseline

      # First Successful Submission
      score 1, :on => 'submissions#create', category: 'Made Submission' do |submission|
        submission.participant.submissions.where(grading_status_cd: 'graded').count == 1
      end

      # Liked First Practice Problem
      score 1, :on => 'votes#create', category: 'Liked First Practice Problem' do |vote|
        challenge_ids = vote.participant.votes.where(votable_type: "Challenge").pluck(:votable_id)
        Challenge.where(id: challenge_ids, practice_flag: true).count == 1
      end

      # Shared First Practice Problem

      # Followed First Practice Problem
       score 1, :on => 'follows#create', category: 'Followed Practice Challenge' do |follow|
        followable_ids = Follow.where(participant_id: follow.participant_id, followable_type: "Challenge").pluck(:followable_id)
        Challenge.where(id: followable_ids, practice_flag: true).count == 1
      end

      # Participated In First Practice Problem
      score 1, :on => ['challenge_participants#create', 'challenge_participants#update'], category: 'Participated In First Practice Problem' do |challenge_participant|
        challenge_participant.participant.challenge_participants.count == 1
      end

      # Shared First Notebook
      # Notebook Was Shared First Time

      # Commented on Notebook
      score 1, :on => ['commontator/comments#create'], category: 'Commented On Notebook', model_name: 'CommontatorThread' do |comment|
        comment.commontable_type == "Post" && CommontatorComment.where(thread_id: comment.id).count == 1
      end

      # Notebook Received First Comment
      score 1, :on => ['commontator/comments#create'], category: 'Notebook Received Comment', model_name: 'CommontatorThread', to: :post_user do |comment|
        comment.commontable_type == "Post"
      end


      # Bookmarked First Notebook
      score 1, :on => 'post_bookmarks#create', category: 'Bookmarked First Notebook', model_name: 'Post' do |post|
        post.post_bookmarks.count == 1
      end

      # Notebook Received Bookmark
      score 1, :on => 'post_bookmarks#create', category: 'Notebook Received Bookmarked', model_name: 'Post', to: :participant do |post|
        post.post_bookmarks.count == 1
      end

      # Downloaded First Notebook
      # Notebook Received Download"

    end
  end
end