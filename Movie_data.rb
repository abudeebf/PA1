#program Name: Moive_data
#  program idea:the program read a data file from user who is watching movie and then try to compute some important statistic as 
# moive popularity , the list of popular movie and try to predict how much user is similar
#to other user , and then suggest the users that are most similiar to one user 
#Author Name:Fatima Abu Deeb
# this program read data from u.data File
class MovieData

   # to intitilaize the instance variables of the class
  def  initialize
    @user_intrest, @movies_rating=load_data
  end
    # =======================this method read from a file
	def load_data
		user=Hash.new{|hash, key| hash[key] = Hash.new} # create a hash of hash data structer
		movie=Hash.new{|hash, key| hash[key] = Array.new} # create a hash of arrays
		File.open("u.data","r") do |file| # open a file and store the content in varabile
          while (line = file.gets) # get a line everytime
            data=line.split(" ") # split the line by placeholder " "
		        user[data[0]][data[1]]=data[2].to_i # store the user Id as the key for hash and the value is hash that store the movie Id as a key and rating as value
		        movie[data[1]].push(data[2].to_i)# store the movie Id as a key and movie ratings array as hash value
		      end # while end 
       end # do end
    return user, movie
  end
    #=================================================================================
    # method that retrun movie popularity as number between 1-5
    # the method will return popularity based on calcultion the mean for the movie ratings
    #===============================================================================
   def popularity(movie_id)
    sum=0 # variable to sum the movie ratings
   	movie_rating=@movies_rating[movie_id].dup # retrive the array of ratings
   	movie_rating.each do |rate| # sum the value in the array
       sum += rate
      end
    if movie_rating.length !=0  # check if the movie ratings array >0
      movie_pop=sum/movie_rating.length # calculate the mean 
    else
  	  movie_pop=sum # sum always =0  because there is no ratings
    end
    return movie_pop 
   end
   #=======================================================
   # method that will retrive the list of pouplar movies in decending order
   def popularity_list
   	movie_popularity=Hash.new 
   	@movies_rating.keys.each do |movie_id|
   	movie_popularity[movie_id]=popularity(movie_id)
    end
    movie_popularity=Hash[*movie_popularity.sort_by{|m,p| p}.reverse.flatten]
    return movie_popularity.keys
  end
  #================================================
  # the method will compute user1 and user 2 similarity based on uclidian distance 
  # if the value return is near for 1 it is mean he is almost similar to the other user
  # the return value between 0 and 1
  def similarity (user1,user2)
	 shared_movies=Array.new # to store the shared movie between the two users
	 user1_pref=@user_intrest[user1].keys # return user 1 preference
	 user2_pref=@user_intrest[user2].keys # return user 2 preference
	 shared_movies=user1_pref & user2_pref # return the intersection between both users
	 users_similar=0
	 if shared_movies.length==0 # mean they are not similiar at all
	 else
		shared_movies.each do |movie_id|
		users_similar+=power(@user_intrest[user1][movie_id]- @user_intrest[user2][movie_id],2) # compute the power of the diffrence between the ratings for the same movie
	   end # end do 
	 end # end if
    users_similar= ((1/(1+Math.sqrt(users_similar))*100).round.to_f )/100 # complete the uclidian distance rule and then round the value to have two dicimal points
  end # end of the method
# method to compute the power
  def power(a,b)
   result = (a ** b)
  end
#===================================
# this method will return the people who is most similar to u user
# the most similiear is the person who is simialrity degree is >0.6 if the user do not have any one with this degree
# the program will retive the maximum degree of similarity he has and then will return the people who is around this similarity
# at a condtion that this degree is more than .1  
  def most_similar(u)	
	 similar_list=Hash.new # to store ths similar users to u
	 user=@user_intrest.keys .dup - [u] # remvoe u from the list of users
	 user.each do |user_Id| # loop thruogh them and then calculate the similarity between u and all user 
	 similar_list[user_Id] = similarity(u,user_Id) # store the degree of similarity in the hash
	 end # end 
   similar_list=Hash[*similar_list.sort_by{|u,d| d}.reverse.flatten] # sort them in decending order and change them to hash
   s_range= similar_list.values[0] # maximum similarity
   if s_range>0.6  
    s_range=0.6
   else
    if s_range>0.1
     	s_range =s_range/2
    end
   end
   final_list=[]
   similar_list .each { |k,m| 
    if m > s_range 
     final_list+=[k]
    end
   }
   return final_list
  end # end method
end # end class
Movie_user=MovieData.new
#Movie_user.load_data
M_popular=Movie_user.popularity_list
M_similar=Movie_user.most_similar("1")
puts " The first 10 pouplar movie is #{M_popular[0..9].inspect} \n"
puts " the last 10 not poplar movies is #{ M_popular.reverse[0..9].inspect}"
puts " the most similar to user 1 is user #{M_similar[0..9].inspect}"
