1
# from DestAllSof:21
class Order < ActiveRecord::Base
    default_scope where(:deleted => false)  # CAUTION, it's change semantic of `all` method so..

    class << self
        alias_method :all_posted_orders, :all
    end
end
class OrdersController < ApplicationController
    def index
        @orders = Order.all_posted_order    #  .. WE make `helper` whick help us save the semantic`
    end                                 # what we need if someone write `default_scope` in your
end                     # model,   SEE for details the problem of helper-and-baclava code in
# main.js@5.5   ... BUT  why I wrote this exmp  ....  SINCE I WANT EMPHASIZE(AGAIN) HOW BAD 
# situation in Rails(and Ruby doesn't help us in this aspect!!!) with mutability-contorl(side-eff)
# and RELATION ON GLOBAL STATE (behavior `all` can be changed due to just some
# `default_scope` setting  ---  IT'S TREMENDOUS)
# .. also
# autor said that some one can write
@orders = Order.all;
# and say that it will write test for it, and if someone add `default_scope`(break initial
# semantic of `all`) -- tests will fail,  BUT autor said(and I agree with him) that it's hard(he 
# said: "a little bit extreme") to write test for every tiny helper(also remeber: we usually test
# public api, but not private helper)  .. AND .. most important .. it DOESN'T PREVEVENT our
# system from being FRAGILE(you should want to write robust system, but not just tested) ..
# .. moreover .. as Miwko(from Angular) said "global state bad for 'easy-for-testing' code"
# ... also in exmp
def recent
    @orders = Order.where("date > ?", 1.week.ago)
end
# if we write test for it like
context "#recent" do
    it "assign the recent orders" do
        orders = stub
        # v-- PIZDEC kak FRAGILE
        Orders.stub(:where).with("date > ?", 1.week.ago).and_return(orders)
#       Orders.stub(:recent).and_return(orders) << MORE ROBUST
        get :recent
        assign(:orders).should == orders
    end
end

8
# we should raise error on first met level(explicitly point out what we want
# string)
def func (str); raise unless String === str; str.str_func; end
# instead of(error if not string raised by 'str_func')
def func (str); str.str_func end # since it means that arg has no semantic
# meaning for our func(in Hskl/Rush such errors catched by static type system)
# P.S. Klubnic called such error as "failures" and I think it right decision
# also SEE onlisp.lisp:427(or OnLisp:p45)

11
# one of reasons of dynamic.langs(Ruby/Lisp) convenience is that, since func
# can receive args of any type and only after that check whether it has
# apropriate type, for such funcs we often can pass values very different types
# and after this funcs convert(if it possible) this args in appropriate type,
# whereas in static.langs it's impossible, and we should convert types
# explicitly.
# P.S. it's convenient to use such funcs what defined in some gem, hovewer it
# slightly unclear and Julia.Manual.31.3 don't recomned to do in such way

18
# in TDD we test only what program do(that is BDD| that is test behavior), and
# principle what 'we write only code to pass tests' guaranty that our tests cover
# all our code

24
# Whreas in Rust, typesystem test what passed arg are pertain to some trait,
# in Ruby we test that when we write stub-methods for args, that is in such way
# we declare what vals we want receive from args and correspondingly what meth
# we will send to args, to receive that vals, as result ........
# I think we should somehow guarantee in our tests what we use only meths what
# imply 'Rust trait'(that is interface of this args), so ...
# for this reason we should use in tests 'should_receive'|'should_respond'
# the meths from ACDE-API what we need for tested proc

25
# pro Rspec:
# test-framework SHOULD BE as simple as possible, in such way that, when my test
# was failed, I don't face situation when I try to understand whether my test
# fail since programm has a bug, or I incorrectly write my tests - !gist! due of
# complexity of test-framework
# But, test framework should support writing tests in BDD style
