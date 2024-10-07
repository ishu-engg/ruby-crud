Rails.application.routes.draw do
  # Get all tasks
  get 'tasks', to: 'tasks#get_all_tasks'

  # route to check typesense connection
  get 'tasks/check_typesense', to: 'tasks#check_typesense_connection'

  # Get task by ID
  get 'tasks/:id', to: 'tasks#get_task_by_id'

  # Create a new task
  post 'tasks', to: 'tasks#create_task'

  # Update a task
  put 'tasks/:id', to: 'tasks#update_task'

  # Delete a task
  delete 'tasks/:id', to: 'tasks#delete_task'


 # Create a new collection in typesense 
  post 'tasks/create_collection', to: 'tasks#create_typesense_collection'

# get all typesense collections
get 'tasks/typesense/collections', to: 'tasks#get_all_typesense_collections'


# get all typesense collections
post '/tasks/typesense/create_task_typesense', to: 'tasks#create_task_typesense'


# get all tasks in typesense
get '/typesense/get_all_tasks_typesense/:collection', to: 'tasks#get_all_tasks_typesense'

# get a task by id
get '/typesense/get_task/:id', to: 'tasks#get_task'

# update a task by id
put '/typesense/update_task/:id', to: 'tasks#update_task_typesense'


# delete a task by id
delete '/typesense/delete_task/:id', to: 'tasks#delete_task_typesense'

  # Set root path
  root 'tasks#index'

  

end