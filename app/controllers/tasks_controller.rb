class TasksController < ApplicationController
    require 'typesense'
    skip_before_action :verify_authenticity_token
  before_action :set_task, only: [:get_task_by_id, :update_task, :delete_task]


   # Initialize Typesense client
   def initialize_typesense_client
    @typesense_client = Typesense::Client.new(
        nodes: [{
          host: 'typesense-typesense-compose.leiusn.easypanel.host',
          port: '',
          protocol: 'https'
        }],
        api_key: 'HHc7/wIE1QFvMu8Y3V6p0Ku8Ln+ObGsFzx8KDb+n4sU=',
        connection_timeout_seconds: 5
      )
  end

  def get_all_tasks
    @tasks = Task.all
    render json: @tasks
  end

  def get_task_by_id
    render json: @task
  end

  def create_task
    @task = Task.new(task_params)
    if @task.save
      render json: @task, status: :created
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  end
 

  def update_task
    if @task.update(task_params)
      render json: @task
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  end

  def delete_task
    if @task.destroy
      render json: { message: "Task deleted successfully for the id #{@task.id}" }, status: :ok
    else
      render json: { error: "Failed to delete task" }, status: :unprocessable_entity
    end
  end


  def create_typesense_collection
    schema = {
      'name' => 'tasks',
      'fields' => [
        {'name' => 'title', 'type' => 'string' },
        {'name' => 'description', 'type' => 'string' }
      ]
    }
  
    begin
      # List all collections
      existing_collections = @typesense_client.collections.retrieve
      collection_names = existing_collections.map { |collection| collection['name'] }

      puts "Existing collections: #{collection_names}"
  
      if collection_names.include?('tasks')
        render json: { message: 'Collection already exists', collection: collection_names }, status: :unprocessable_entity
        return
      end
  
      # Create the collection
      typesense_client.collections.create(schema)
      render json: { message: 'Typesense collection created successfully' }, status: :created
    rescue Typesense::Error => e
      Rails.logger.error "Typesense Error: #{e.message}"
      render json: { error: e.message }, status: :unprocessable_entity
    rescue StandardError => e
      Rails.logger.error "Unexpected Error: #{e.message}"
      render json: { error: "Unexpected error: #{e.message}" }, status: :internal_server_error
    end
  end
  

  def get_all_typesense_collections
    begin
      # Retrieve all collections from Typesense

      typesense_client =  Typesense::Client.new(
        nodes: [{
          host: 'typesense-typesense-compose.leiusn.easypanel.host', # Use the correct host here
          port: '',
          protocol: 'https' # Use 'http' or 'https' depending on your Typesense setup
        }],
        api_key: 'HHc7/wIE1QFvMu8Y3V6p0Ku8Ln+ObGsFzx8KDb+n4sU=', # Ensure this is the correct API key
        connection_timeout_seconds: 5
      )
      collections = typesense_client.collections.retrieve
      render json: collections, status: :ok
    rescue Typesense::Error => e
      Rails.logger.error "Typesense Error: #{e.message}"
      render json: { error: e.message }, status: :unprocessable_entity
    rescue StandardError => e
      Rails.logger.error "Unexpected Error: #{e.message}"
      render json: { error: "Unexpected error: #{e.message}" }, status: :internal_server_error
    end
  end

  def check_typesense_connection
    begin
      Rails.logger.info "Attempting to connect to Typesense..."
      client = Typesense::Client.new(
        nodes: [{
          host: 'typesense-typesense-compose.leiusn.easypanel.host', # Use the correct host here
          port: '',
          protocol: 'https' # Use 'http' or 'https' depending on your Typesense setup
        }],
        api_key: 'HHc7/wIE1QFvMu8Y3V6p0Ku8Ln+ObGsFzx8KDb+n4sU=', # Ensure this is the correct API key
        connection_timeout_seconds: 5
      )
      
      health = client.health.retrieve
      Rails.logger.info "Typesense health response: #{health.inspect}"
      render json: { status: 'Connected', health: health }, status: :ok
    rescue Timeout::Error => e
      Rails.logger.error "Connection Timeout: #{e.message}"
      render json: { status: 'Not Connected', error: "Connection timeout: #{e.message}" }, status: :service_unavailable
    rescue Typesense::Error => e
      Rails.logger.error "Typesense Error: #{e.class} - #{e.message}"
      render json: { status: 'Not Connected', error: "Typesense error: #{e.message}" }, status: :service_unavailable
    rescue StandardError => e
      Rails.logger.error "Unexpected Error: #{e.class} - #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
      render json: { status: 'Not Connected', error: "Unexpected error occurred: #{e.message}" }, status: :service_unavailable
    end
  end

  def create_task_typesense
    # Assuming you receive the book parameters in the request body
    task_params = params.require(:task).permit(:title, :description)

    # Prepare the book data for Typesense
    task_data = {
      'id' => SecureRandom.uuid, # Generate a unique ID for the book
      'title' => task_params[:title],
      'description' => task_params[:description]
    }

    typesense_client = Typesense::Client.new(
      nodes: [{
        host: 'typesense-typesense-compose.leiusn.easypanel.host',
        port: '',
        protocol: 'https'
      }],
      api_key: 'HHc7/wIE1QFvMu8Y3V6p0Ku8Ln+ObGsFzx8KDb+n4sU=',
      connection_timeout_seconds: 5
    )

    begin
      # Insert the book into the Typesense collection
      typesense_client.collections['tasks'].documents.create(task_data)

      render json: { message: 'Task created successfully', task: task_data }, status: :created
    rescue Typesense::Error => e
      Rails.logger.error "Typesense Error: #{e.message}"
      render json: { error: e.message }, status: :unprocessable_entity
    rescue StandardError => e
      Rails.logger.error "Unexpected Error: #{e.message}"
      render json: { error: "Unexpected error: #{e.message}" }, status: :internal_server_error
    end
  end


  def get_all_tasks_typesense

    collection_name = params[:collection]
    typesense_client = Typesense::Client.new(
      nodes: [{
        host: 'typesense-typesense-compose.leiusn.easypanel.host',
        port: '',
        protocol: 'https'
      }],
      api_key: 'HHc7/wIE1QFvMu8Y3V6p0Ku8Ln+ObGsFzx8KDb+n4sU=',
      connection_timeout_seconds: 5
    )

    # Ensure a collection name is provided
    if collection_name.blank?
      return render json: { error: 'Collection name is required' }, status: :unprocessable_entity
    end

    begin
      # Search all tasks in the Typesense collection (with optional parameters)
      search_params = {
        'q' => '*',  # Search for all tasks
        'query_by' => 'title,description' # Fields to search by (modify based on your schema)
      }
      result = typesense_client.collections[collection_name].documents.search(search_params)
      render json: result['hits'].map { |hit| hit['document'] } # Return all matching documents
    rescue StandardError => e
      render json: { error: e.message }, status: :internal_server_error
    end
  end

  def get_task
    typesense_client = Typesense::Client.new(
      nodes: [{
        host: 'typesense-typesense-compose.leiusn.easypanel.host',
        port: '',
        protocol: 'https'
      }],
      api_key: 'HHc7/wIE1QFvMu8Y3V6p0Ku8Ln+ObGsFzx8KDb+n4sU=',
      connection_timeout_seconds: 5
    )
  
    begin
      # Use 'fetch' to get a specific document by ID
      @task = typesense_client.collections['tasks'].documents[params[:id]].retrieve

      render json: @task
    rescue Typesense::Error::ObjectNotFound
      render json: { error: 'Task not found' }, status: :not_found
    rescue StandardError => e
      render json: { error: e.message }, status: :internal_server_error
    end
  end
  

  def update_task_typesense
    typesense_client = Typesense::Client.new(
      nodes: [{
        host: 'typesense-typesense-compose.leiusn.easypanel.host',
        port: '',
        protocol: 'https'
      }],
      api_key: 'HHc7/wIE1QFvMu8Y3V6p0Ku8Ln+ObGsFzx8KDb+n4sU=',
      connection_timeout_seconds: 5
    )
  
    begin
      # Retrieve the current document data
      current_task = typesense_client.collections['tasks'].documents[params[:id]].retrieve
  
      # Merge the existing data with the updated params to form a complete document
      updated_task_data = current_task.merge(task_update_params.to_h)
  
      # Update the task document by ID with the complete data
      @task = typesense_client.collections['tasks'].documents[params[:id]].update(updated_task_data)
      render json: @task
    rescue Typesense::Error::ObjectNotFound
      render json: { error: 'Task not found' }, status: :not_found
    rescue StandardError => e
      render json: { error: e.message }, status: :internal_server_error
    end
  end

  def delete_task_typesense
    typesense_client = Typesense::Client.new(
      nodes: [{
        host: 'typesense-typesense-compose.leiusn.easypanel.host',
        port: '',
        protocol: 'https'
      }],
      api_key: 'HHc7/wIE1QFvMu8Y3V6p0Ku8Ln+ObGsFzx8KDb+n4sU=',
      connection_timeout_seconds: 5
    )
  
    begin
      # Delete the task document by ID
      typesense_client.collections['tasks'].documents[params[:id]].delete
      render json: { message: 'Task deleted successfully' }, status: :ok
    rescue Typesense::Error::ObjectNotFound
      render json: { error: 'Task not found' }, status: :not_found
    rescue StandardError => e
      render json: { error: e.message }, status: :internal_server_error
    end
  end
  
  def task_update_params
    params.require(:task).permit(:title, :description)
  end
  

  private

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:title, :description)
  end
  def task_update_params
    params.permit(:title, :description)
  end
end
