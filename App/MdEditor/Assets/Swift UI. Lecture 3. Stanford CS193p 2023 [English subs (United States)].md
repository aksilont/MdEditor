This is probably the most slides 
you're going to see me do in a row  

the whole quarter long but we do need 
to cover some basic architecture before  

we dive into the next part of the demo 
which will be the second half of today.

Any questions before I start? Okay 
good. All right, so lecture number 3. 

We've got two huge topics to talk about, 
one is MVVM which is the architecture,  

the design paradigm that you're going to use to 
build an app, and then the Swift type system:  

the different types that are in there 
like struct and protocol and all that. 

So those are the two major topics and 
then I'm going to dive back in the demo  

and we're going to start building the game 
logic for our Memorize app. All the things  

about what happens when you click on cards 
and all that we need to build all that. 

All right, so, this MVVM 
thing, what's that all about?

Well, in Swift, to say that it's important 
to separate the logic and data part of  

your app from the UI would be a dramatic 
understatement. It's really, really important. 

Swift UI, in a way, is all built around this idea 
that you're going to have your data and logic,  

what your app does, over here, and then you're 
going to have the UI that shows that to the user  

and interacts with the user, as a separate 
thing. So that's just really important.

The logic and data side of it, so 
in our Memorize app it's the "what  

happens when you click on a card? and 
are the cards face up or face down?",  

all that stuff, we call that part of 
our app "the Model." You're going to  

hear me use that word Model hundreds of 
times. All that stuff lives in the Model.

We call the stuff we've been doing so 
far in the class "the UI" or sometimes  

we'll call it "the View" because it's 
our view, our portal, onto the Model.

Now, the Model, it could be a single struct. 
It could be a whole SQL database full of  

stuff. Maybe it's some machine learning 
code. Maybe it's like a REST API over  

the Internet. It could be almost anything. 
It's conceptual. Our Model is conceptual,  

it's not just a single struct, although 
with our Memorize app it is going to be a  

single struct because this is super simple 
little first starter app. But I don't want  

you to think that your Model couldn't be 
way, way more powerful and complicated.

Now, the UI part of our app really is just 
like a parametrizable shell that the Model  

feeds. One of the best phrases I've heard for the 
UI is it's a visual manifestation of the Model,  

because the Model is what your app is, 
it's a Memorize game, that's what it is,  

so all that logic is in the Model. The 
UI, it's just how you show that to the  

user. It's a visual manifestation of it. 
So you really want to think of it that way.

For what we've done so far, isFaceUp, cardCount, 
these things that we've been putting in @State,  

they belong in the Model. Those are all things 
about the game we're playing. So we don't want  

those things in the UI, so I will be getting 
rid of them, putting them into our Model.

One of the things that Swift does, super 
important, one of its responsibilities,  

is to make sure that anything changes in the 
Model, it appears in the UI. So it's got an  

enormous amount of infrastructure to do that for 
you. That's one thing you have to understand:  

you're not really going to be responsible, that 
much, for making whatever's in your Model appear  

in the UI. Swift is going to mostly do that for 
you. You've just got to give Swift some hints  

about what in the Model affects your UI. But once 
you do that it's going to do it so don't worry  

too much about that part of it. Mostly you're 
going to worry about separating these things out.

If we separate these things out, the UI and 
the Model, how do they connect to each other?  

Because obviously they need to talk to each other. 
Well, I boiled it down to three different ways of  

connecting it here. There's probably some other 
ways, but I think most things would fit in one  

of these three categories. Rarely, one way 
we could connect the Model to the UI is to  

have the Model be @State in a View. I mean if you 
put the entire Model, all the logic in your app  

into an @State in your View, then obviously the 
View could access it. This is extremely minimal  

separation. I probably wouldn't do that. I'll 
talk about when we would do that soon. Number 2  

is that the Model is only accessible to the UI 
via a gatekeeper. We're going to have a gatekeeper  

and that guy's job is to keep the UI and the 
Model communicating with each other safely,  

coordinating communication. This is the main way 
we're going to do it, this is this MVVM thing I'm  

talking about. Number 2 here is 99% of the time 
you build an application. And then I throw out  

number 3 here which is kind of a hybrid of the 
first two, which is, there is this gatekeeper,  

which we call the View Model, there but sometimes 
it'll allow direct access to the Model. It'll  

have a var that's public that the UI could look at 
that var and actually talk directly to the Model,  

directly to the Memorize game. That's a hybrid of 
the first two essentially. So how do we know which  

of these things to do? Well, the easy answer 
is always do number 2. That's what I'm going  

to advise. Just always do number 2, especially 
when that previous slide when I said the Model  

could be SQL databases and all these things you 
definitely need number 2 in that case because the  

the this thing in the middle, this intermediary, 
it's the thing that knows how to do SQL and all  

that. You don't want your UI to have to be making 
SQL calls. Your UI is just presenting information  

on screen. It should all be simplified for your 
UI. So that's why you would always do number 2.  

But if it's very, very, very simple Model, even 
simpler than our Memorize, it might want to do  

this @State solution especially if the View 
maybe just comes on screen really briefly,  

it has a little bit of data, maybe it's like image 
data that it's showing or something like that,  

and then it goes away and it's gone forever, 
then maybe you don't need this extra gatekeeper  

guy. And then the third one is maybe you're in 
between, like our Memorize game could be that  

hybrid. You're going to see when we build our 
Memorize game, yeah, we have this intermediary  

the gatekeeper but a lot of time the gatekeeper is 
just forwarding on requests from the UI directly  

to the Model, so you could make the argument, just 
let the UI see the Model directly and still have  

the gatekeeper to do some other bookkeeping. I 
don't like number 3 because as your app grows  

you start building a tangled mess where your UI 
is now talking directly to your Model through this  

gatekeeper guy and it just doesn't grow very well. 
It doesn't, it's not a flexible growth system,  

so even though you might have to do a little 
bit of work to protect your Model from your UI  

with this gatekeeper, that seems a little bit 
like why are we wasting our time doing that,  

it still can be worth it, especially as your app 
grows and becomes more powerful. And you'll see  

that in the demo because I'm going to show 
you both number 2 and number 3 in our demo.

We're going to talk about number 2, this MVVM. The 
reason it's called MVVM, that stands for Model,  

View, View Model. That's what the M, V and 
VM are. The Model, you know what that is,  

I told you. Your View is another word for 
the UI. And View Model is this gatekeeper  

in the middle that I was telling you about. 
It's kind of an interesting name, View Model,  

because its job is to connect the View to the 
Model and be the gatekeeper between the two. So  

I kind of like the name View Model. Weird 
word, but that's what we're going to see.

So here's a picture of MVVM. There's my Model 
over there. Here's my View. And we'll get to  

the thing in the middle in a second. So 
let's talk about the Model in this whole  

architecture. The Model is UI independent. We are 
not even going to import SwiftUI in our Model.  

It is truly UI independent. In our Memorize 
game, it's going to play a game of Memorize,  

with anything on the cards: jpeg images, we're 
going to use emoji, but it can do anything. It's  

a generic, UI-less, Memorize-game-playing thing. 
UI independent, important to understand that part  

in the Model. As I said before, it's the data of 
your app, like whether the cards are up or down,  

and the logic, like what to do when you choose 
a card, which cards to flip over and stuff,  

it's both of those things combined. It's very 
important to understand that the Model is the  

truth for all of these things so if you want 
to know the data or you want to perform some  

logic you have to talk to the Model. There's 
no "copying this data somewhere else" like into  

this View Model thing I'm going to show you, or 
certainly not into @State in your UI. You would  

never do that. If you want the information 
you go back to the Model. It's the truth.  

Anything the Model knows, you should always 
be asking the Model for it, at all times

Now, let's talk about the View. What 
is the View? Well, the View, as I said,  

it's a visualization of the Model. The View 
should always look like what the Model looks like.  

Whatever's happening in the Model, 
you should see that on screen.  

The View, because of that, is stateless. It 
doesn't hold any state. It's just always showing  

you what's in the Model. So it doesn't need any 
state. That's why any state we have in the View  

we mark @State so we realize, oh we have state in 
our View, that's not good, this is supposed to be  

stateless. It's okay to have @State in very 
rare circumstances, but it's unusual and it's  

specially marked like that so that we are aware 
that we're doing this thing that really is rare.  

Views are mostly stateless, they're just showing 
you constantly what's in the Model at all times.

You've probably already noticed this but our 
View is declared. We don't write the code for  

our View in an imperative fashion. You guys know 
what the word imperative means? That's like when  

you're writing code, you're calling a function 
then you call another function to make something  

happen and then you call another function you're 
writing imperatively. In our View you noticed we  

just had our var body and we just listed the 
Views that went in our UI. We modified them  

with View modifiers but we basically just listed 
them. They're just sitting there. A VStack of,  

you know, cards and the buttons. We're saying what 
it is. We're declaring this is our UI and then the  

Model data drives it. Any part of our UI that can 
vary is changing because our Model is changing and  

causing it to change. So we declare. So it's 
declarative. And that results in this word we  

see a lot which is "reactive," that's because 
the UI is reacting to changes in the Model.  

Model changes, UI updates, because it has to 
because it's always showing what's in the Model.  

Now we can talk about this MVVM 
thing. And it works like this ...

We're going to introduce another actor into 
this thing, the View Model, and the View Model  

is going to bind the View to the Model. Its 
job is to connect these things to each other.  

So this line that comes across right here and 
says "data flows this way read only", right,  

because this is stateless and it's being fed by 
this. This guy up here is going to intervene in  

this line and he's not only binding them he's 
also interpreting them, like this might be SQL  

and this doesn't make SQL calls so it's the thing 
that has to make SQL calls, turn them into normal  

variables or something so the View can see them, 
right, so it's doing interpretation of the Model.  

It also is a gatekeeper between these two 
guys. It's protecting the Model so that the  

UI can never do anything bad to the Model. 
And I'm going to show you how it does that,  

the main way it does that, in a minute 
here. So it's a gatekeeper, an interpreter,  

it's the thing that controls the 
flow here between these two things.  

So basically that line goes up and through there. 
The data flows through the View Model to the View.  

How does this all work? Well, things happen in 
the Model and it's this View Model's job to notice  

those changes. So, again, SQL database, it's got, 
you know, it's signed up with a SQL database to  

get notified when things change. If it's a Swift 
struct, it's fantastic. Swift's really good at  

telling you when something in a struct changes 
and you'll see why that is when we talk about  

the type system. Whatever it is, the View Model 
has to notice the changes. Now, when it notices  

the changes, it then publishes to the whole world 
"something changed in the Model". Once the View  

Model says something changed, that's when Swift 
UI kicks in. And it looks at its View, it says oh  

something changed, did anything change that means 
I have to redraw? and it's super smart about this.  

It's only going to redraw the Views that actually 
were affected by this change, and it does that for  

you, so you don't have to worry about it. You 
don't have to do anything to make that happen.  

So this is the process: notice change, publish 
that changes happen, Swift automatically figures  

out which Views have to be redrawn and it 
draws them. How does it know this? how does  

it figure this out? again, it's all about 
this functional programming, about the fact  

that structs in Swift are value types, we can 
see when they change very easily, it's built-in  

to know when they've changed, that's all because 
of Swift. Swift enables this to happen and we're  

not going to talk about the mechanism for that 
right off the bat here but it's pretty cool.

I'm just putting these things here 
like these View modifiers and these  

little @ things like @State but they're 
different. I'm just putting them up here  

for future reference. I'm not going to talk 
about any of them right now but later in the  

quarter when you see me talk about one of 
these things you can think back and say,  

oh I'm gonna go look at that MVVM slide 
and see oh yeah that's right it was an  

MVVM thing. So we'll we'll be talking about 
like @ObservedObject and ObservableObject and  

@Published in the next lecture or so, but some 
of the other ones a little later in the quarter.

So that's the basics of MVVM going this 
way. But there's a big question here:  

what about the other way? Because the 
View, you can tap on things, right,  

you can swipe and do things. The user can interact 
here and that could affect the Model. So how do  

we go that way? Because I told you this arrow 
only goes this way and it does only go this way.  

Well, that is done by processing "user intent" 
and that's another thing the View Model does.  

When someone taps on something in the View they 
call a function in the View Model saying "the  

user has the following intent". For example, in 
our Memorize game, the user wants to choose this  

card. You're not going to have a method in View 
Model called "tap". That would make no sense.  

That's a UI thing. You would have a method in your 
View Model called "choose this card". You see,  

it's a user intent. The user intends something 
semantically meaningful to the Model. But then,  

once again, the View Model's job is to turn that 
into a bunch of SQL calls or something like that,  

whatever makes sense to express that intent in 
the Model. All right, so it's very important  

this idea of intent. Now, sometimes intent like 
"choose a card," our Model, our Memorize Model,  

it's going to have a choose card method that's 
just fundamental to it, so it's going to seem  

kind of weird, like our View Model is hardly doing 
anything, it's just forwarding the message on. But  

it's still being a gatekeeper, it's still binding 
them together, it's just that our first app is  

really simple. But in the second app we build, 
you're going to see that there are intents that  

can't be mapped directly to a single call in 
the Model. Anyway, that's what happens here,  

is intent. Now what happens when that intent 
gets called in the View Model? Well of course  

the View Model modifies the Model in whatever 
way to express whatever the user's intention is.  

Then, what happened before happens again: the 
Model changed, the View Model notices the changes,  

it does all this publishing of something changed, 
the View does its thing and it updates. Same exact  

thing as happened before. So when it comes to 
going this way the only thing is the intent.  

Once you call the intent, the View Model updates 
the Model and then the normal update happens. Our  

stateless UI is reflecting the new state of 
the Model after the intent that we expressed.

And that is it. That is the entirety of MVVM.

So let's go to the next step in the architecture 
here which is the type system. Every language,  

it's just so important to understand the 
fundamental types that are involved, right,  

because everything that the language can do 
really flows out of those fundamental types.  

So let's talk about the types here. Now I don't 
have time, because I want to do some demo today,  

to talk about all the types, so I'm going to talk 
about structs and classes, and then these "don't  

care" types, which are kind of fun, and then for 
protocols, I'm going to talk half about protocols,  

that's why I say protocol "part one". I'll 
talk about more protocols in lecture 5 or so.  

I'm going to skip enums not because enums aren't 
important, they are, enums are an important type,  

but I just won't have time to do everything 
and I do need to talk about this last type  

which is functions. And yes, I'm talking 
about types here: functions are types.

So let's talk about these types.

struct and class, very similar, so I'll kind of 
compare them in these first two slides. They have  

almost exactly the same syntax and you've already 
seen it, right, you say struct ContentView: View.

class, very similar, but inside there they both 
have vars they can be stored like isFaceUp, right,  

just a stored variable, normal variable. They 
also both have computed vars like var body, right,  

we compute the value of the var. They also both 
can have constant lets. Remember let versus var,  

lets are constants, vars are variable. Both have 
functions and I just want to remind you here that  

in functions, our parameters here can have names 
like "operand" and "by" right there and that they  

can also have two names: an external name and 
an internal name. The blue is the external name  

and the purple internal name. I'll use this 
on the inside callers use the blue name you  

saw that in the last demo. They both have that, 
structs and classes all have all these things.  

They also both have something we haven't 
talked about which is initializers.  

Now, we saw RoundedRectangle, when we created 
it we created it with a cornerRadius of 12 or  

whatever, but when we were typing "corner" it 
also was offering us this other one, cornerSize:,  

where we could kind of do both the X and Y of the 
corner not just a radius. And that's because the  

RoundedRectangle has two initializers. And you 
can have any number of initializers you want  

and they can all have different arguments. You 
can take whatever arguments you want as long as  

you initialize your struct or your class, that's 
fine. Now we haven't needed any initializers so  

far because, and I'll talk about this in the next 
slide, we've used the "free" init. You get a free  

init with structs and classes. They're different, 
but you get a free one and we have been using the  

free one like when we created our CardView 
we use CardView(content: "") remember that  

we got a free init there that allowed us to call 
that and I'll talk about that in the next slide.  

In the demo, we're also going to write our 
own init, because it is flexible and nice  

to be able to specify your own arguments to 
create your thing. They're really simple,  

init looks just like a func but you don't say 
"func init" you just say "init" and you can have  

as many of them as you want. When we create 
our memory game over there, Memorize game,  

we're going to initialize our game with the number 
of pairs of cards we want. Even though "number  

of pairs of cards" is not going to be a var, 
we're going to have an array of cards instead.

So what's the difference then? struct and class  

got all these things all exactly 
the same. What's the difference?

Well, this is really important to understand 
and what's good about this is understanding not  

only from the Swift language perspective 
but because most of you are coming from  

object-oriented programming, so you're 
used to classes and Swift has classes,  

and so when I'm comparing structs to classes 
it's kind of like comparing what you know to  

what you're going to be doing. Because you're 
going to be doing 99.9% struct in this class,  

okay, the only thing we're going to use a class 
for, believe it or not, is that View Model,  

that gatekeeper thing. That will be a 
class. But everything else will be a struct.

All right, so, the biggest difference between 
structs and classes is that structs are value  

types and classes are reference types. Does 
anyone know ... raise your hand if you think  

you know what that means? Okay a few of you. So, a 
reference type means that when you have a variable  

that is a class you don't actually have the class 
stored in that variable you have a pointer to it.  

It lives in the heap somewhere. You have a 
pointer to it. You have a reference to it,  

right, it's a reference type. And that's what 
you're used to, okay, almost all languages,  

object-orienting languages, they have references 
to their classes. Now what's good about that?  

Well, I guess what's good is, you could have 
20 different pieces of code all sharing the  

same class, right, they all have a pointer 
to it they can all modify it and everything.  

What's bad about that? Well, you could have 10 
different things all pointing to the same class  

and they're all modifying and how do you know one 
of them's not screwing it up for everybody else?  

So that's the good and the bad of reference types.

It turns out Swift believes the bad outweighs 
the good, so they don't use reference types for  

most things in Swift. So what's the alternative? 
Value types. What does that mean? Well, a value  

type means that the storage for the variable 
is actually right there. There's no pointers.  

It's actually stored right there and it also has 
some things that fall out from that, for example,  

when you pass a value type to a function you get 
a copy of it. In fact, even when you assign one  

variable to another you just made a copy of the 
other one. Every time the thing gets passed around  

or assigned, it's getting copied. Copied, copied, 
copied. Not pointer. And why is that good? Because  

if you give a copy like you pass it to a function 
and then that guy mucks it up he only mucks it  

up for himself. He didn't muck it up for you 
because you gave him a copy and he worked on that.  

Now the flip side of this is it requires a lot of 
different thinking when you're writing your code,  

for example, if you have a struct and you want 
to give it to a function to modify then you would  

give it to the function they would modify it 
and they would probably return you the new one,  

right, so the return value of the function, 
like, here's that new thing you wanted. And  

you saw this actually, probably, when 
you looked for Array's shuffle(), right,  

there's Array's shuffle() which shuffles the 
array in place that only works if you have a var  

and then there was shuffled() with a "d" on the 
end which gives you back a new Array, shuffled.  

You see? And that shuffled(), that's 
more the kind of Swift way to do it.

Now, we'll talk about in a couple of 
bullets here how we do the "shuffle  

in place" when we have this going 
on, we'll explain that in a second,  

but that's important to understand, and 
then again the class again you're passing  

around a pointer so everybody's pointing 
to the same thing they're all sharing it.

Now, another interesting thing is if you 
have a class and you're handing out all  

kinds of pointers to it, when do you know how 
to clean up the memory? When do you know I'm  

done with this object, this class? Well in a 
lot of languages you do garbage collection,  

right, and you go look in the heap, you do 
a mark and sweep, nobody's pointing to this,  

I'm going to clean this up. whatever your strategy 
is. Turns out Swift's strategy is a great one,  

it's called automatic reference counting, where 
it keeps track in real time how many pointers are  

there to this, and when that count goes to zero 
it immediately cleans out the memory. So it's  

really nice, even though we don't use classes, 
it's still really nice that they have this  

feature in there. So what happens on the struct 
side, on the struct side it uses copy-on-write,  

because when I say that you're passing these 
things around by copying them I mean all structs.  

If you had Array of a million items in there, 
when you pass it to a function it would copy it.  

Now that would be impossible if it was really 
a million items in terms of performance, right,  

you can't copy a million item Array. But 
Arrays are structs, so what happens is,  

when you pass it behind the scenes, it's not 
actually going to copy it until someone writes  

on it, and once someone modifies that Array 
now they get their own copy. And so the whole  

thing is based on copy-on-write. Now when you 
have copy-on-write, guess what? You know when  

things change. You have to know when that Array 
changed or how do you know when to copy it? Well,  

I told you before in the MVVM, Swift is really 
good about knowing when structs change. It's  

built into Swift to know this struct was actually 
changed. That is just fundamental because it can't  

do the copy-on-write otherwise, and without the 
copy-on-write, constantly passing around Arrays  

of a million items would just not work. Just 
wouldn't work. And this works incredibly well,  

Swift is incredibly efficient. If you build your 
code, even if you're processing large data sets,  

it's really, really efficient because it does 
this copy-on-write built in to the very language.

Now as you're probably getting the message 
here, structs are the foundation of functional  

programming. They're right at the base of 
what we're doing. classes are the basis  

for object-oriented programming. Why do we 
choose one of these styles over another?  

Well, object-oriented programming came out 
of this idea, I talked about it before,  

data encapsulation. Wanna encapsulate the 
data of a real world concept or thing and then  

associate all the functionality with that data 
by encapsulating it all into one structure with  

functions about that data, right? That's what 
object-oriented programming is, I think we can  

all agree, and it adds this idea of inheritance 
because some things are very like other things,  

but with some minor modifications, and so we 
can inherit from them and then tweak them to  

be a specific instance of that or whatever. That's 
great, but functional programming has a different  

take on it, which is that it's not the data that 
we wanted to encapsulate, it's the functionality.  

So all we're going to really do is describe how 
things behave. I've already said this before,  

right, like how a View behaves or whatever, we're 
going to describe that formally in our language  

and then we're going to be able to know which 
things can do what and we can ask them to do it.  

And when it comes to the data, that's behind the 
scenes. Like how an Array stores its things, who  

cares? What we know is that an Array has a whole 
bunch of functions and vars on it that we can  

call that'll do certain things and we don't really 
care about the data, and we never care about it,  

and if it totally changed its mind about that 
we wouldn't care too. So functional programming,  

it's fundamental to functional programming, that 
we have these value types because in functional  

programming one of the real things we want is 
provability. Have you all heard about this concept  

of provability in computer science? You want to 
be able to take a piece of code and prove that it  

will do what it will do no matter what, no matter 
what environment it's in or whatever. You can't  

do that in object-oriented programming because 
you don't know who's going to have a pointer  

to your class who might mess the whole thing up, 
increment some counter or do something like that,  

whereas here with functional programming, you 
can, because you're always passing a copy of  

the thing in there and it does what it does and it 
returns the modified thing back so that's always  

going to happen. Nobody can interfere with that 
from outside that function will always do what it  

says it's going to do and you can prove it with 
test cases or whatever you can prove what it's  

doing. So it's just a different way of thinking 
about programming much more about provability  

and functionality based design and this is much 
more about data encapsulation and kind of modeling  

the real world, although we can model the world 
just as well in functional programming because  

in the real world things behave like certain 
things so we can do it there too, just as much.

All right, so there's no inheritance at all in 
structs because inheritance is limiting. If I  

had two things that are kind of similar but one's 
not really a subset to the other it's like they  

want to share some functionality but they can't 
inherit. Inheritance is limiting unnecessarily,  

so there's no inheritance. There is inheritance 
of course in this side because Swift is trying  

to be an object-oriented language and also it 
has to have backwards compatibility with the  

old way of programming in iOS which is all 
class-based, so it has single inheritance,  

regular, normal inheritance that you're used to.

This init thing, I told you we got a 
free init, they both get free inits,  

totally different. A struct, the free init you get 
is an init that initializes all of the variables:  

isFaceUp and content, all of them. And of course 
if any of them are defaulted then you don't have  

to put them on there but that's what you get. 
If you don't do your own init, you get a free  

one that has all. With the class, if you don't do 
your own init, you get one that does none of them.  

But it's still required that all of them be 
initialized so the only way you can use the  

free init in a class is essentially if 
you put is equal to something for every  

single variable. They have to all have default 
values because you only get this free one. So  

in classes we almost always have inits 
because this is such a weak free init.  

In structs we often don't have inits 
because the free one is so powerful.

In object-oriented programming, 
the objects are always mutable.  

You have a pointer to them. You can always go 
through that pointer and change the object.  

Dangerous. That's why anybody can change 
your object. It's dangerous. Here in structs,  

mutability is explicit: if something is in a let 
you can't mutate it, if it's in a var you can. So  

if I had an Array and it's in a var, I can call 
shuffle() on it because shuffle() shuffles it in  

place. Or I could call append() to add something 
to it. Or I could subscript it and assign one of  

the things to something else because it's a var, 
it's in a var, stored in a var. If it's in a let,  

things like shuffle() don't even exist. Now if 
you call shuffled() with a d, that would work,  

right, because that doesn't modify the Array it 
just shuffles it and returns a new one to you.  

So this is explicitly managed, which is 
really awesome as a programmer to know  

that you have some piece of state that can be 
modified or not. It's just, it's wonderful.

So the question is: can I use a let for a class? 
You can, but all you're talking about there is the  

pointer. The thing it points to is always mutable. 
Okay, the pointer is not mutable, who cares?  

right? I mean, you have the pointer. lets are 
allowed but they don't really mean much over here.

So structs are your go-to data structure. 
99% of everything you're going to do  

in this class is a struct. We're 
doing functional programming here.  

Sometimes you'll hear me also say, because 
whenever I say functional programming,  

I always throw in there "or protocol-oriented 
programming," you could call it that. I'm  

going to talk about protocols in a second and 
you'll see why I keep throwing that in there.  

Pure functional programming doesn't have 
some of the things that Swift does with its  

protocols so it's a combination of functional 
programming and protocol-oriented programming.

And here we either use this for backwards 
compatibility to the old iOS which none of you are  

going to be doing that's six years old by now. Old 
news. Or we would use it for our View Models. Now,  

why do we use a class for our View Model? Here's 
why: our View Model is shared, very much shared,  

between maybe lots of different Views. 
Lots of Views want to get at the Model.  

I might have a score View in my Memorize game 
that wants to show the score of the game,  

so it wants to get at it, so you want to have 
a pointer to the shared View Model, the shared  

View Model that's looking at the Model. But the 
key here, the reason it works here, is that the  

View Model is a gatekeeper. It has walls up that 
are protecting the Model, right, that's its whole  

existence, is as a gatekeeper, so having a shared 
pointer to it, it's not going to get damaged.  

Its whole job is to not allow damage. It's its 
whole interface, the whole programming interface  

to it, is a protected, gatekeeping kind of 
interface. So it's a time where we can take  

advantage of the shared nature of having 
a pointer to it that we can hand out to  

point at from all these Views but we're safe 
because its whole job is to be a gatekeeper.

All right, Generics. So I talked about this 
earlier: Array, right, an Array of Ints, Array  

is kind of generic, because you can put anything 
in there. Let's talk about how this really works,  

this stuff. Sometimes you want to build a struct 
and it has some data associated with it and you  

don't care what type it is. Array, the classic 
example there. We call that being "type agnostic"  

about that type. I like to use the phrase "it's 
a don't care" because I don't care what it is.  

Swift, though, is strongly-typed. Remember I said 
that? That's a problem because you've got to know  

what that type is. Swift does have a thing 
that is not typed but it's just for backwards  

compatibility with that old iOS stuff, okay, we 
never use it when we're actually using Swift.  

So Swift is strongly typed. Every single thing, 
every variable has to have an actual, strong type,  

and then we do that nice type inference to make 
it so we don't have to type it so much. But  

they all still have a strong type. So if we're 
doing Array and we want to have Ints in there,  

we have to have a type for Int, so how do we 
specify this type we don't care about? Well, we  

use generics and here's what the syntax looks like 
for generics. We're going to imagine Array, and  

let's pretend that we're going to write the Array 
struct, okay, we're the authors of it. We're going  

to need to have variables and functions that are 
of this "don't care" type, like if I say append()  

to the Array and Int well that that append() 
method, its argument has to be a type Int, so  

I need that type when I'm building my programming 
interface for Array. So let's look what it would  

look like approximately if we were to build our 
own struct Array. So here it is struct Array, and  

it's got its functions and vars in there, but it's 
got . That  means: I'm Array,  

I have a "don't care" called Element. This Element 
can be any type, any type in the entire Swift type  

system here (unless maybe a function I guess) but 
it could be a certainly a struct or a class or an  

enum and this type is something that Array doesn't 
care what it is but it's going to use it in its  

programming interface. func append(), there's the 
Element, it's a type Element. So when does this  

thing become a real type well of course when we 
create it. When I say var an equals an Array of  

Int, now Element is Int for me. Whenever I'm using 
a, Element is an Int. so append() takes an Int,  

a subscripting returns an Int. It's as simple as 
that. So you notice that this angle bracket thing,  

it kind of matches what the guy who wrote 
struct did. angle brackets right after the name,  

angle brackets right after the name when you're 
creating one. I think the thing that makes this  

hard to understand is people are like wow I can't 
really think of an example of when I would use  

this, right? It's like Array, yeah I get it, of 
course, but ... So in our demo we're going to do  

that. We're going to create our own generics. 
It'll make a lot more sense when I do that.

Here I just want to emphasize that you 
could have multiple of these generics.  

So Array could have multiple. 
You can declare as many of these  

don't cares as you need to define your 
classes. It's totally allowed there.

All right, so this is actually called "type 
parameter" because we're kind of parameterizing  

the Array type with that little Element thing, 
but I'll call them "don't cares." I just think  

"don't care" is much more visceral. It makes much 
more sense. That's a don't care. I don't care what  

that type is. Now one thing about Swift's don't 
cares, or it's generics, it really uses them a  

lot. It's really fundamental to Swift and we're 
going to combine it with protocols and it's really  

going to be powerful. Once you throw protocols 
into the mix of these don't cares ... I'll give  

you a preview: imagine that you have a don't 
care that you force to behave like something.  

Now you've made your don't care be "oh 
I care a little bit about this" and that  

allows you a lot of flexibility to build 
programming interfaces. We'll see that in  

our demo. We're going to do that in our demo 
as well and so I won't talk too much about it.

But before we can talk about that we 
need to understand protocols more and  

again I don't have time to talk 
all about protocols but let's get  

a little bit of an understanding 
what's going on with protocols.

You already have seen the View protocol, so you're 
probably already getting an idea. Let me talk a  

little more formally about it. A protocol looks 
like, when you see it in code, kind of like a  

class or a struct that has no implementation. 
So here's a protocol called Moveable and it's  

got a function move(by:) some Int. It's got a var 
called hasMoved and another var distanceFromStart.  

But notice no implementation here the move(by:) 
has no curly braces after it, and the two vars  

just say { get } or { get set }. The curly braces 
after a var in a protocol just say whether this  

is a read-only var or a var you can get and set. 
That's all that appears in the curly braces. No  

implementation. So protocol is just a description. 
I'm sure you can all make the leap quickly to why  

we do this? because we're just describing behavior 
here. Just functionality. We're not actually  

providing any functionality we're just saying we 
want to have things that behave like a Moveable  

and if we want to behave like a Moveable 
you need to implement Moveable which  

means you need to implement move(by:) 
and hasMoved and distanceFromStart.  

So remember that when we said we behaved like a 
View we had to implement var body? If we want to  

implement Moveable and behave like a Moveable we 
have to implement all three of these things. When  

you claim to implement a protocol, or you claim 
to behave like a protocol, you have to implement  

all the things in that protocol. Literally 
no way around that. I use this thing "behaves  

like a" ... it's the same way as like I call 
it "don't care." It's just more visceral here,  

but "conforms to" is really the right words. 
When I have a struct that does this : Moveable,  

we're saying that PortableThing 
"conforms to" the Moveable protocol.  

I like to say it behaves like a Moveable, but 
that's the real words, the real thing we'd say.

Does everyone understand that? That's what 
a protocol is: just functions and vars,  

no implementation. Just so 
we can say that other things  

behave that way. Just so we can make 
contracts between objects basically.  

It's also legal to have protocols, like protocol 
Vehicle, that behave like other protocols. It's  

kind of like, we call this protocol inheritance, 
because Vehicle has its own var but it's inherited  

these ones. So if I want to have a Car which is 
a Vehicle, I have to implement all four things  

because I've inherited both of them. So it's 
protocol inheritance, that's totally allowed.

You can also of course have your Car, or whatever, 
implement multiple protocols. That just means they  

have to implement all those things. In other 
words, I'm just saying here that you can have  

comma another one, comma another one, and it's 
actually quite common to do this. We'll be  

doing this in our demo, we're going to implement 
multiple, uh, we're going to behave like multiple  

things. So what do we use a protocol for? Well, 
a protocol is a type. I'm talking about the type  

system, it's a type. And so you can use it as 
a type. A type of a var or as an argument type  

passed to a function. var body, actually, its 
return type, er, it's a var, but it's type that  

var body, it's a View, something that behaves like 
a View. Of course we've got the "some" in there  

which makes it so it's automatically calculates 
it for us from our computed property, but it is  

of type View and View is a protocol. So you can do 
that. I am actually not going to talk about that  

right now even though that seems like wow that's 
really important. It's really ... it is important,  

but there's other things that are more important, 
so I'm not going to talk about that. That'll be in  

part two of protocols, how do we use a protocol 
as just a type, a type of a var or a parameter.  

So what am I going to talk about? Well, I'm going 
to talk about the way you've seen it already,  

which is super important, which is to specify the 
behavior of a struct, class or an enum. We say  

struct ContentView behaves like a View by doing 
this and we know that when we did this we had some  

things we were required to do like, implement 
var body, and that we got a ton of things,  

a whole bunch of funcs, you know, View 
modifier functions like foregroundColor,  

and all these things that apply to all Views. 
I call this "constrains and gains." So this is  

using protocols for constrains and gains. You're 
going to constrain some structs and classes or  

enums or whatever, like constrain them such that 
they have to implement var body if they want to  

behave like a View, but you're going to get gains 
like a whole bunch of functions or whatever. And  

this constrains and gains idea is true for 
all uses of protocols. protocols are always  

constraining because they're making you implement 
certain things but they provide a kind of a  

framework for you to then get a bunch of gains. 
And I'm not going to talk a lot about the gains,  

it goes back to this extension thing, how we 
make this happen, but constrains and gains  

is a big part of what protocols are all about, 
right, huge gains. So we're going to see quite  

a variety of protocols even in the next couple of 
lectures like Identifiable, Hashable, Equatable,  

CustomStringConvertible, Animatable, tons and 
tons of protocols. Pretty much in everything  

we do we start doing these protocols and we do it 
so we can both constrain things and gain things.

Another use of protocols I hinted at before, which 
is to turn our "don't cares" into "care a little  

bits." So if struct Array had been declared as 
Array where Element "behaves like an  

Equatable," then you could only put things into 
Arrays that you could do == on, because that's  

what the Equatable protocol is: ==, right, when 
you say that x == y that == is actually part of  

a protocol in Swift called Equatable. So luckily 
they didn't define it this way because we can put  

things into Array that aren't Equatable. Had 
they done it using this where clause, see that  

magic word "where," we could constrain that don't 
care to be a "care a little bit" and we're going  

to do that in our demo as well. All right, does 
that make sense how we could use protocols here?  

It's just a way to make our don't 
cares a little more like we care.

All right, so more about protocols 
in part two. Once we have extensions,  

the gains part of constrains and gains is going 
to go off the charts over there. And we're also  

going to talk more about "some" and "any" you 
know like "some View" and there's another one  

called "any" that are really good for 
using protocols as types like when you  

want to put things in an Array and you want 
the Array to be any kind of a certain thing  

that behaves like something, then you have 
this nice "any" keyword that helps you put  

that in there. So we'll learn all about that 
in protocols part two in a couple of weeks.

Here's an overview of protocols just understanding 
why do we do this protocol stuff. It's just a way  

for structs and classes and enums and stuff to 
say what they're capable of and to demand certain  

behavior out of other structs, classes and enums, 
right, that's what it's fundamentally about. But  

the great thing is that neither side has to reveal 
anything about what they are. They don't even  

have to say whether they're a struct or a 
class or an enum, they just have to say,  

yes, I Implement that protocol. So it hides the 
implementation behind this protocol and hidden  

implementation is good because you can then change 
it, you know, you can change it without breaking  

anything because you've hidden the actual struct 
or class that's implementing something. It's  

also a way to add a ton of functionality via this 
extension thing, which I haven't talked about yet.

It's really, when we say that Swift is a 
protocol-oriented programming language,  

this is why we're saying this, because 
it's all about the functionality and we  

describe what the functionality 
is via these protocols, right,  

that's why we say it's a functional programming 
language, protocol-oriented programming language,  

they go together. This is why they go together 
so much, it's how we describe the functionality.

All right, functions. This is the last 
type in the type system I'm going to talk  

about. The only thing to get from 
these slides: functions are types,  

okay, they're first-class types and here's 
how it works ... You can declare any variable  

or parameter to a function or the return 
type of a function to be of type function,  

and this syntax for the type function includes the 
arguments and the return type of that function.  

You can do it pretty much anywhere another type 
is allowed, there are some restrictions actually,  

but certainly parameters, function return values, 
variables, they can all be of type function.

So here's some examples ... This one here in 
yellow, that is a type called "a function that  

takes two Ints and returns a Bool." That's what 
that type is. Here's another type, this type is "a  

function that takes a Bool and returns nothing." 
That's what -> Void means right there. This is a  

function that takes no arguments and returns an 
Array of Strings and here's one that takes no  

arguments and returns nothing. This is a common 
type we see. We can have variables that are of  

these types, we could have parameters that are of 
these types, that are passed to functions. They're  

just types. Here, for example, is a variable 
foo, its type is "a function that takes a  

Double and returns nothing" or here's a function, 
doSomething, it has an argument "what" which is of  

type "function that takes no arguments, returns 
a Bool." It's kind of exactly what you'd expect.  

The only thing maybe you wouldn't expect is 
notice none of these include parameter names,  

so when you're specifying a type that is a 
function, you don't include the parameter names.  

Just the actual types of their return values and 
arguments. So how do we use something like this?  

Here's a var "operation" that's of type "function 
that takes a Double and returns a Double" and here  

I have a function that I wrote called square, 
and square happens to take a Double and it  

returns a Double. It returns the operand times the 
operand. Do we all agree that that's a function  

that takes a Double and returns a Double? 
Well then I can say operation equals square  

because operation is of type function that takes 
a Double and returns a Double and square is a  

function that takes a Double returns a Double so I 
can say operation equals square and I can now call  

operation just as if it were square. I can say 
let result = operation(4), and that's going to  

work because operation is a function that takes 
a Double this is a Double and returns one, so  

result's going to get it and it's going to be 16. 
Because operation is currently square, but I could  

reassign operation and say operation equals sqrt, 
so sqrt is a built-in function in Swift that takes  

a Double and returns a Double, sqrt of it. Now if 
I say let result = operation(4), I get 2, you see,  

because operation is a different function now. I'm 
not going to take the slide time here to show this  

doing the same thing for a function argument 
because we're going to do that in our demo.

Closures. You've heard me talk about closures. 
We often call them inline functions. We call  

them closures for a reason, hopefully if 
you're doing your reading, I believe we're  

covering that in the reading this week. 
Closures capture the environment of the  

variables that exist when the closure is inline, 
right, a closure is just an inline function,  

we've seen closures all over the place so 
far in the code we've done in this class.  

There's a lot of built-in support for it, these 
ViewBuilders were closures, when we did the  

onTapGesture, it had closure, when we did Button's 
action that was a closure. These are all closures.  

I'm not going to talk a lot about closures 
and how they capture the environment,  

I'm going to leave that to your reading and 
then you're going to see me doing it in class,  

it'll make sense then. It actually turns out that 
on the UI side, the capturing nature of closures,  

we don't use it that much. Mostly if you want 
to think of closures as just inline functions  

you can do that, but hopefully closures now make 
more sense how they are arguments to functions.  

Like remember ZStack(content:{ and then we put 
the ViewBuilder stuff in there? Well content in  

ZStack is just a parameter to its creation and 
its type is "a function that takes no arguments  

and returns a View." That's all it is, nothing 
special there, that's all it is. The only thing  

that's a little special is that it's a ViewBuilder 
so it has that magic that turns the list of Views  

into one TupleView combined View, so it's got that 
magic, but when it's declared it's just of type "a  

function that takes no arguments returns a View." 
We're doing functional programming here in Swift,  

these are really, really important, right, 
closures, functions as types, we're just going  

to be doing this all the time in this class. I 
take some time on this because I know that for  

some of you it's like, whoa, functions as types, I 
can't imagine this, but it'll become very natural,  

once we start having some variables and 
functions that take these as arguments,  

you'll be like, oh yeah, yeah, yeah, I get it, 
it's really, really cool, and it is really cool.

All right, so that is it for 
the slides today. Like I say,  

that's the longest run of slides 
I'll do all quarter, but those are  

two important things to understand: 
that MVVM thing and all these types.

And so let's get back to the demo. 
What we're going to do in our demo  

is we're going to start building 
the Model for our Memorize game,  

and then in the next lecture, we'll build 
our View Model and hook it up to our UI.

Here we go. This is where we left off last time. 
Now, I'm going to take a little time here to clean  

out a little bit of the code that we put in there. 
You were allowed to do this in your assignment as  

well. I'm just going to go through here and remove 
these Buttons at the bottom. I have these Buttons  

down here. Just to clean up the code because 
you understand how that works, it's not really  

helping to be in our face, so we can remove this. 
The Spacer() and the cardCountAdjusters there,  

we don't actually need this to be in a VStack, 
I guess, we could just have it be ScrollView. 

And we don't need the cardCountAdjusters here. 
By the way, one thing I would have done probably,  

you see how I created a one-liner cardAdder here, 
once I added this I probably would have put this  

up there inline and it probably wasn't worth it to 
have just a one-liner there. It wouldn't be wrong,  

but it probably wasn't worth it either. And let's 
see, we don't need cardCount anymore because we're  

not adding or removing, so let's have this 
go back to being the emojis.indices instead. 

That's everything. Yeah we're 
back to working over here. 

We've got our UI, I'm actually not going to 
touch this UI in this lecture, instead we're  

going to totally do Model only and they're totally 
separated, right, so I shouldn't have to touch my  

UI, which I'm not going to, and I'm going to 
create my Model in a totally different file. 

So in Xcode here, I'm going to go File > 
New > File... That's how I add a file to my  

project. The Model is going to live in a totally 
separate file. You'll notice down at the bottom,  

it says User Interface, Swift UI View? That's 
one you might choose if you're creating a View,  

we're not, so we're going to choose Swift file. 
You almost never choose these other things unless  

maybe you're doing unit tests or something like 
that. Most of those other things you're not doing,  

C++ you're not doing, Metal probably, maybe for 
your final project you might be, but we're going  

to choose Swift file here. I'm going to call my 
Model MemorizeGame, MemorizeGame, and remember  

that it is the game it is the actual logic and 
data of the game. One thing important to do,  

see what that Group right there is? That's the, 
this is the group that's going to put the file in,  

this is something students really forget to do so 
I'm going to take some time to make sure I make it  

clear what's happening here is you don't really 
want to put your files up at the top level where  

your xcodeproj is, right, you know if you look in 
your directory, you've got the xcodeproj and then  

you've got something there called Memorize, that's 
this folder, that's where you want to put your  

files. So, the one way to kind of make sure you're 
doing the right thing, so if you click through,  

this is the folder you want to put it in, this 
one here. If you don't do it, it's not the end  

of the world, but it's just going to start looking 
a little ugly because you're going to have random  

files, Swift files, up at the top level instead 
of putting them down in this nice Memorize.

So we create it. Here it is. Here is our Model, 
and our Model starts out saying import Foundation,  

not import SwiftUI. That's because we said 
create a Swift file instead of a SwiftUI View,  

and that's exactly what we want here. Foundation, 
that module, is just Arrays and Ints and Bools,  

Dictionaries, non-UI things. Nothing in 
Foundation has anything to do with UI and if  

you find yourself having to do import SwiftUI 
here in your Model, you're doing it wrong,  

because Models are UI-independent. They should 
not have import SwiftUI. Now our MemoryGame is  

just going to be a struct so I'm going to say 
struct MemoryGame, and it's not going to behave  

like anything for now so I'm just going to put 
the curly braces after there. And when I build my  

Model, one thing I almost always do is try to stub 
out, when I'm starting, what does this thing do?  

and what's its, what data does it have associated 
with it? Just to get me started. I might change  

my mind and use a different data structure or 
whatever, but I want to kind of make that clear  

in my mind, at least as some straw-man before I 
start going. So our MemoryGame, what's it got?

I should have left those physical cards up but 
they probably wouldn't appreciate that in other  

classes, and I'm not taking them up and down 
because they take a lot of hooking up there.

What what does it do? Well, it definitely has 
a bunch of cards. Can we all agree we probably  

need some kind of var cards? And it's an 
Array of something, I'm not sure what,  

I'll call it, Array of Card, how about that? I 
definitely want that. Do we all agree with that?  

And what is a ... how do we play our game? We 
basically choose cards, right? Choose card,  

choose card, and matches or not or 
whatever, so I probably need some function 

choose(card: ), and it's 
also of this little type Card  

and that's it. That is my entire Model, because 
that is all our MemoryGame does. It has a bunch  

of cards, you choose them, and it plays. Now, 
in your assignment two you're going to be asked  

to do some additional things like scoring so 
you're going to probably add something here,  

the score probably an Int or something, a var Int, 
or a Double if you want double precision scoring.  

You're going to add that, but for our basic game 
that we have so far, this is really all there is. 

But what about this Card thing? It's saying cannot 
find type Card in scope. So we're gonna have to  

think about what a Card looks like in our Model. 
So let's have a little nested struct called Card.  

You see how I put this Card inside this struct. 
That's not only allowed, it's really good for  

name-spacing because the name of this struct is 
actually MemoryGame.Card because I put it on the  

inside of it, and that's what I want because I 
don't want some generically named struct "Card"  

floating around in my app. Maybe I'm building, 
you know, an app that has 20 card games in it.  

I don't want this Card to be called Card I want 
to be MemoryGame's Card, right, so this nesting  

is really nice. But it's almost entirely just a 
name-spacing thing, but it's a nice feature there. 

So what do we know about a Card? What 
kind of information it has? Well,  

there's whether it's face up, that's a 
big one we know that it's going to have.  

What else do we want to know about 
a card? Anybody think of anything?

If it's been matched, absolutely, 
so we'll have an isMatched,  

that's a Bool. What else would 
we want to know about a card?  

Yeah, like what's on the card. I didn't bring a 
card today, but remember my cards had Halloween  

themed things on there, witches and spiders and 
things, so we got to know what's on there. So  

that's interesting, we'll call it "content," it's 
the content of the card. What type should this be?  

A String? If it's, we're doing emoji, right, 
then String because emojis are Strings,  

I guess it could be Character also. 
There's a type in Swift called Character  

and that'd be maybe okay, but I actually have 
a better idea. Let's make this a "don't care,"  

because we're making a card game and we don't 
care what's on the cards. Put anything you want on  

there: jpeg images, emojis, whatever. So 
let's make this a don't care. So how do we  

put a don't care here? First of all let's just 
make up a name for it, I'll call it CardContent.  

This is a type I'm just making 
up. And I could put it here,  

CardContent, as a don't care, right, it becomes 
a don't care, but actually that's really not  

going to work very well because that would 
mean here I would have to say what the type  

was because remember whenever I have a don't 
care, whenever I use this thing, like here,  

I have to then say what it actually is. So that's 
a little bit of a conundrum. But easily fixed,  

because I'm just going to take this and make 
the don't care be on the entire MemoryGame.  

Now MemoryGame, including its little sub-struct 
here all have this don't care that can be used  

anywhere inside MemoryGame. That's one thing 
to understand about a don't care is the wider  

the scope you put it the more it'll apply to 
sub-structs. So we have this. Look, no errors!

Okay, we have no errors up here and we got this 
CardContent, it could be any type, could be a  

String for our emojis, it could be an image, 
the jpeg image, it could even be some UI thing  

and I said this was UI-independent, it can't have 
anything UI, but whoever creates this MemoryGame  

is going to be in the UI, probably in a View 
Model, right, the View Model is part of the UI,  

by the way, the View and the View Model 
are both considered parts of the UI,  

they're going to create the MemoryGame. They 
could specify a UI thing because they're UI,  

that's part of it, so here, inside 
here though, we are not doing any  

UI. So that's a cool feature too: your don't 
care can make it so that you can use things  

in the UI kind of through your Model but 
your Model is actually still completely  

UI-independent because it doesn't care, it 
does not care what you put on these cards.

So that truly is just about all 
there is to do with our Model here.  

I have five minutes left 
let me think about this ...

Yeah, let's do it. I'm going to create my View 
Model and we're going to come back to this. We  

obviously haven't implemented our MemoryGame's 
logic but that's all there is to our MemoryGame:  

it just has the cards, we choose them, 
they're face up, matched, content.

So let's create our View Model, 
this is the gatekeeper between this,  

our Model, and that UI that we've built.

That looks like this ...
New > File ... 

Again it's a Swift file, it's not a View. A View 
Model is not a View. And I'm going to call this  

EmojiMemoryGame because this View Model is going 
to be specific to an emoji MemoryGame. If I had  

one that was jpeg image or something maybe I would 
have a JPEGImageMemoryGame. Now it is possible I  

could also build my View Model to be generic and 
it could have a don't care as well but I'm not  

going to propagate that up, but I could. It's 
totally legal to have don't cares on your View  

Model. But I'm not... mostly for simplicity 
of this demo, I'm not gonna go that far with  

our don't care. So this particular View Model 
is going to be specific to emoji MemoryGames.  

This will only work for MemoryGames where it's 
emoji. So here we go, create that, and this one  

is going to import SwiftUI because your View 
Model is part of your UI. It has to be because  

remember it's packaging up the Model for the UI 
so it has to know what the UI looks like. It has  

to be part of your UI. But, I say that, but, the 
View Model is not going to be creating Views or  

any of that stuff, okay, the View is going to be 
doing that. But this will know about the UI and  

it will know about UI-dependent things like colors 
and things like that, images, it knows about that.

So this is a class because it's going to be 
shared amongst everything and I'm going to  

call it EmojiMemoryGame. And a class, if it had 
inheritance, would be right here, MySuperclass or  

whatever. We're not going to do inheritance. We 
don't need to inherit from anything to be a View  

Model so we'll leave that off. But it could 
also "behave like" something, so, you know,  

SomethingWeBehaveLike, right, some protocol could 
be here. And you could have one without the other,  

like maybe I don't inherit anything but I 
do behave like something. That's legal too.  

The only thing is that if you do have 
a superclass you want to list it first  

in that list, before you list the things you 
behave like. That's the only restriction there.  

Now my View Model is the conduit between my 
Model and my UI so it needs connectivity to  

the Model because it needs to talk to the Model. 
For example if the UI, the View, had an intent  

like "choose a card,", the View Model has to be 
able to talk to the Model and express that intent,  

so we almost always need variables here for our 
Model. Now I'm going to call mine "model." This  

is a bad name. This is a name that you 
would only use for instructive reasons,  

okay. You would call this something like "game" 
because that's what it is. You always want to  

pick names where it is what they are. I'm going to 
call this "model" just so you constantly are going  

to be reminded what's Model and what's View Model, 
and when we go back to our UI on Monday, I'm going  

to call that variable "viewModel" so that you'll 
be able to see which one's which. So I have a  

model and what's its type? Anyone want to guess 
what the type of this model, my model is here?

No guesses? It's a MemoryGame, right, 
because I said this was an emoji MemoryGame  

and so it's going to create 
a MemoryGame, that Model,  

it's of type String. Everybody cool 
with that? I just took that generic  

type and specified the don't care. The 
don't care is a String right there.

Well now let's, let's not go over time. I'll stop.

So we have two errors, two things to do right 
off the bat, we'll do on Monday. One is saying  

EmojiMemoryGame has no initializers, you see 
it has no init and remember I told you that  

classes only get a free init which initializes 
nothing and this var has not been initialized so  

that's why it's making this complaint right here.
So we'll have to fix that obviously and the other  

thing I'm going to do right off the bat on Monday 
is talk a little bit about what I was telling  

you about the partial separation versus the full 
separation mechanism. We're doing full separation  

here because we're creating a View Model in 
between, but I'm going to show you how this Model  

can be protected. Right now the UI could see this 
Model because it's just a var in my class. It can  

see it in the View Model, but I'm going to protect 
it so they can't see it, so the UI cannot see it,  

and then I'm gonna be a gatekeeper. So we'll start 
that off on Monday and we'll implement the rest of  

this and then we'll go make our UI use all this.
All right, that is it!

