FROM reslim30/marqs_environment:1.0

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

# Copy the Gemfile and Gemfile.lock into the image. 
# Temporarily set the working directory to where they are. 
# This is to cache bundle install
WORKDIR /tmp 
ADD Gemfile Gemfile
ADD Gemfile.lock Gemfile.lock
RUN bundle install 

# TODO: figure out how to cache yarn install
RUN yarn install
RUN yarn add webpack

# Now copy working directory
WORKDIR /usr/src/app
COPY . .

RUN rake db:drop db:create db:migrate db:seed 

CMD ["rails", "s", "-b", "0.0.0.0"]