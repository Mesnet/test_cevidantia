# spec/action_spec.rb
require_relative '../../models/action'  # adjust if your file is in another folder

RSpec.describe Action do
  let(:valid_action) { Action.new(who: 'driver', type: 'debit', amount: 3000) }

  describe "initialization" do
    it "creates a valid action for driver debit" do
      expect(valid_action.who).to eq('driver')
      expect(valid_action.type).to eq('debit')
      expect(valid_action.amount).to eq(3000)
    end

    it "defaults to type 'credit' if not specified" do
      action = Action.new(who: 'owner', amount: 1500)
      expect(action.type).to eq('credit')
    end

    context "when type is invalid" do
      it "raises an error" do
        expect {
          Action.new(who: 'driver', type: 'foobar', amount: 1000)
        }.to raise_error(RuntimeError, /type should be one of/)
      end
    end

    context "when who is invalid" do
      it "raises an error" do
        expect {
          Action.new(who: 'someone_else', type: 'debit', amount: 1000)
        }.to raise_error(RuntimeError, /who should be one of/)
      end
    end
  end

  describe "#to_h" do
    it "returns a hash with who, type, amount" do
      action_hash = valid_action.to_h
      expect(action_hash).to eq({
        who: 'driver',
        type: 'debit',
        amount: 3000
      })
    end
  end
end
