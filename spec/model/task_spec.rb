# spec/models/task_spec.rb

require 'rails_helper'

RSpec.describe Task, type: :model do
  describe "validations" do
    it { should validate_presence_of(:title) }
    it { should validate_inclusion_of(:status).in_array(["To Do", "In Progress", "Done"]) }

    context "when status is 'To Do'" do
      before do
        allow(Task).to receive(:too_many_todo_tasks?).and_return(true)
      end

      it "adds an error if there are too many tasks in 'To Do' status" do
        task = Task.new(title: "Test Task", status: "To Do")
        task.valid?
        expect(task.errors[:status]).to include('Too many tasks in To Do status')
      end
    end

    context "when status is not 'To Do'" do
      it "does not add an error for 'To Do' limit" do
        task = Task.new(title: "Test Task", status: "In Progress")
        task.valid?
        expect(task.errors[:status]).not_to include('Too many tasks in To Do status')
      end
    end
  end
end
