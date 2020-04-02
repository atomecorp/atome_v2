# frozen_string_literal: true

require 'core_ext'

describe Array do
  context '#delete_at_multi' do
    subject do
      [
        'alpha',
        'bravo',
        'charlie',
        'delta',
        'echo',
      ]
    end

    # FIXME: It is unexpected that #delete_at_multi does not behave like #delete_at.
    # I would expect it to return an array of the removed items, and update the array in place.
    # The following tests check this behaviour.
    xit 'remove a single item' do
      expect(subject.delete_at_multi([2])).to eq(['charlie'])
      expect(subject).to eq(['alpha', 'bravo', 'delta', 'echo'])
    end

    xit 'remove items in order' do
      expect(subject.delete_at_multi([2, 3])).to eq(['charlie', 'delta'])
      expect(subject).to eq(['alpha', 'bravo', 'echo'])
    end

    xit 'remove items in reverse order' do
      expect(subject.delete_at_multi([3, 2])).to eq(['delta', 'charlie'])
      expect(subject).to eq(['alpha', 'bravo', 'echo'])
    end

    xit 'remove inexistent items' do
      expect(subject.delete_at_multi([12, 10])).to eq([nil, nil])
      expect(subject).to eq(['alpha', 'bravo', 'charlie', 'delta', 'echo'])
    end

    xit 'remove repeated items' do
      # FIXME: Removing the same item repeately should probably not remove other items...
      subject.delete_at_multi([2, 2, 2])
      expect(subject).to eq(['alpha', 'bravo'])
    end
  end

  context '#pick' do
    # FIXME: I don't get the point of that function.  These tests are minimalists.
    subject do
      [
        {
          'color' => [
            'red',
            'green',
            'blue',
          ],
        },
      ].pick(prop, mode)
    end

    context 'with a singular prop' do
      let(:prop) { 'color' }
      context 'with mode=value' do
        let(:mode) { :value }

        it { is_expected.to eq(['red', 'green', 'blue']) }
      end
      context 'with mode=electron' do
        let(:mode) { :electron }

        it { is_expected.to eq('color' => ['red', 'green', 'blue']) }
      end
    end

    context 'with a plural prop' do
      let(:prop) { 'colors' }
      context 'with mode=value' do
        let(:mode) { :value }

        it { is_expected.to eq([['red', 'green', 'blue']]) }
      end
      context 'with mode=electron' do
        let(:mode) { :electron }

        it { is_expected.to eq([{ 'color' => ['red', 'green', 'blue'] }]) }
      end
    end
  end

  context '#swap!' do
    subject { [0, 1, 2, 3, 4] }

    context 'when in bounds' do
      it 'swaps items' do
        subject.swap!(1, 3)
        expect(subject).to eq([0, 3, 2, 1, 4])
      end
    end

    context 'when out of bounds' do
      # FIXME: The behaviour with out-of-bounds value confuses me.  Maybe we can raise an exception in this case?
      xit 'does something really weird #1' do
        subject.swap!(10, 11)
        expect(subject).to eq([0, 1, 2, 3, 4, nil, nil, nil, nil, nil, nil, nil])
      end
      xit 'does something really weird #2' do
        subject.swap!(10, 0)
        expect(subject).to eq([nil, 1, 2, 3, 4, nil, nil, nil, nil, nil, 0])
      end
      xit 'raise an error' do
        expect { subject.swap!(10, 0) }.to raise_error(RuntimeError)
      end
    end
  end
end
