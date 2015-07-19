class UserSerializer < ActiveModel::Serializer
  attributes :id,
             :full_name,
             :display_name,
             :email,
             :date_of_birth,
             :gender,
             :facebook_url,
             :twitter_url,
             :personal_message,
             :webpage_url,
             :is_banned,
             :is_banned_date,
             :number_of_posts,
             :number_of_comments,
             :legal_terms_read,
             :privacy_terms_read,
             :is_admin,
             :is_super_user,
             :sign_in_count,
				 :password,
				 :number_of_comments,
				 :number_of_posts,
				 :last_sign_in_at,
				 :reset_password_sent_at,
				 :reset_password_token
end
