# sinatra_more Ideas

before/after filters only for certain routes:

    before :only => [:show, "/account"] do
     # ... actions ...
    end

    after :only => [:show, "/account"] do
     # ... actions ...
    end
 
resource routing (defines mapped routes)
    
    map(:user).resource
    # => EQUIVALENT TO:
    map(:new_user).to('/users/new') # NEW
    map(:edit_user).to('/user/:id/edit') # EDIT
    map(:user).to('/user/:id') # SHOW, UPDATE, DESTROY
    map(:users).to('/users') # INDEX, CREATE

benchmarking and logging
  
    create logger and Sinatra.logger methods
    to make logging with severity easy

    Sinatra.logger.info "Print something to log"

model generators (creates model, test, migrate)

    sinatra_gen model Article
    sinatra_gen --destroy model Article

migration generator (creates migration file)

    sinatra_gen migration CreateArticleIndices

controller generators (routes, test, helpers)

    sinatra_gen controller articles
    sinatra_gen --destroy controller articles

mailer generators (mailer file, view path, test)

    sinatra_gen mailer UserNotifier confirmation

task support (in generated app)

    padrino console
    padrino test
    padrino db:create
    padrino db:migrate
    
(Note in mailers, check out adv\_attr\_accessor)