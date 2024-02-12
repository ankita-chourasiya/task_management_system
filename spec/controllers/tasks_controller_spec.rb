require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  describe 'GET #index' do
    it 'returns a success response' do
      get :index
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      before do
        allow_any_instance_of(TasksController).to receive(:task_params).and_return({ title: 'Task Title', description: 'Task Description', status: 'Done' })
      end

      it 'creates a new task' do
        expect {
          post :create
        }.to change(Task, :count).by(1)
      end

      it 'returns a created response' do
        post :create
        expect(response).to have_http_status(:created)
      end
    end

    context 'with invalid attributes' do
      it 'does not create a new task' do
        expect {
          post :create, params: { task: { title: nil } }
        }.not_to change(Task, :count)
      end

      it 'returns an unprocessable_entity response' do
        post :create, params: { task: { title: nil } }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PUT #update' do
    let!(:task) { FactoryBot.create(:task) }

    context 'with valid attributes' do
      before do
        allow_any_instance_of(TasksController).to receive(:task_params).and_return({ title: 'New Title', description: task.description, status: task.status })
        allow(task).to receive(:update).and_return(true)
      end
  
      it 'updates the task' do
        put :update, params: { id: task.id, task: { title: 'New Title' } }
        task.reload
  
        expect(task.title).to eq('New Title')
      end

      it 'returns a success response' do
        put :update, params: { id: task.id, title: 'New Title' }

        expect(response).to be_successful
      end
    end

    context 'with invalid attributes' do
      before do
        allow_any_instance_of(TasksController).to receive(:task_params).and_return({ title: nil, description: task.description, status: task.status })
        allow(task).to receive(:update).and_return(false)
      end

      it 'does not update the task' do
        put :update, params: { id: task.id, task: { title: nil } }
        task.reload

        byebug
        expect(task.title).not_to be_nil
      end

      it 'returns an unprocessable_entity response' do
        put :update, params: { id: task.id, task: { title: nil } }

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:task) { FactoryBot.create(:task) }

    it 'destroys the requested task' do
      expect {
        delete :destroy, params: { id: task.id }
      }.to change(Task, :count).by(-1)
    end

    it 'returns a success response' do
      delete :destroy, params: { id: task.id }
      expect(response).to be_successful
    end
  end
end
