class Todopoint < ApplicationRecord
  
  enum todo_type: { bug: 0, improvement: 10, story: 20, done: 30 }

end
