require 'test_helper'
require 'vedeu/support/interface_template'

module Vedeu
  describe InterfaceTemplate do
    it 'creates and stores a new interface' do
      interface = InterfaceTemplate.save('widget') do
                    colour  foreground: '#ff0000', background: '#5f0000'
                    cursor  false
                    width   10
                    height  2
                    centred true
                  end
      interface.must_be_instance_of(Interface)
    end

    it 'allows interfaces to share behaviour' do
      IO.console.stub :winsize, [10, 40] do
        main =    InterfaceTemplate.save('main') do
                    colour  foreground: '#ff0000', background: '#000000'
                    cursor  false
                    centred true
                    width   10
                    height  2
                  end
        status =  InterfaceTemplate.save('status') do
                    colour  foreground: 'aadd00', background: '#4040cc'
                    cursor  true
                    centred true
                    width   10
                    height  1
                    y       main.geometry.bottom
                    x       main.geometry.left
                  end

        main.geometry.left.must_equal(15)
        main.geometry.top.must_equal(4)
        status.geometry.left.must_equal(15)
        status.geometry.top.must_equal(5)
      end
    end

    describe '#x' do
      interface = InterfaceTemplate.new('widget')

      it 'raises an exception when the value is out of bounds' do
        proc { interface.x(0) }.must_raise(XOutOfBounds)
      end

      it 'raises an exception when the value is out of bounds' do
        proc { interface.x(999) }.must_raise(XOutOfBounds)
      end
    end

    describe '#y' do
      interface = InterfaceTemplate.new('widget')

      it 'raises an exception when the value is out of bounds' do
        proc { interface.y(0) }.must_raise(YOutOfBounds)
      end

      it 'raises an exception when the value is out of bounds' do
        proc { interface.y(999) }.must_raise(YOutOfBounds)
      end
    end

    describe '#width' do
      interface = InterfaceTemplate.new('widget')

      it 'raises an exception when the value is out of bounds' do
        proc { interface.width(0) }.must_raise(InvalidWidth)
      end

      it 'raises an exception when the value is out of bounds' do
        proc { interface.width(999) }.must_raise(InvalidWidth)
      end
    end

    describe '#height' do
      interface = InterfaceTemplate.new('widget')

      it 'raises an exception when the value is out of bounds' do
        proc { interface.height(0) }.must_raise(InvalidHeight)
      end

      it 'raises an exception when the value is out of bounds' do
        proc { interface.height(999) }.must_raise(InvalidHeight)
      end
    end

    describe '#centred' do
      it 'should hav a valid spec, please write one.' do
        skip
      end
    end
  end
end
