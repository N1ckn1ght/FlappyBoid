# FlappyBoid

It's a clone of the famous Flappy Bird!

### Controls

Only mouse works:

**LMB** or **RMB** to make a jump (to get instant velocity);

**MMB** for pause.

### Demonstration

There're a lot of game modes.

https://www.youtube.com/watch?v=2ox4L14E_F4

https://www.youtube.com/watch?v=I1ebQk9hJZk

### Future plans

I want to make usable table of records and in-game help.

### Screenshots

![love 2022-12-04 21-32-44-404](https://user-images.githubusercontent.com/50321432/205496213-47b6c630-e08b-45ae-b422-51cc0c3ae1f8.png)

![love 2022-12-04 21-33-31-809](https://user-images.githubusercontent.com/50321432/205496216-0fdb02d8-d1e3-4c05-bd17-3b27ac60f799.png)



### Game modes (aka Difficulties) description

**Easy** - Boid behaves normal, pipes are rarer than normal, gaps are slightly bigger than normal. Pipe ends are, however, narrower significantly. Velocity and acceleration like Normal.

**Normal** - This difficulty was made as supposed to play. While it's not incredible interesting when you've learnt how to, it still has acceleration and might have velocity up to 4.8x from starting.

**Hard** - Boid less controllable, has higher gravity force on it and bigger velocity on click. All other stuff like Normal.

**Insane** - Boid behaves like at Hard, pipes are more frequent than normal and gaps are slightly smaller that normal. Pipes are also slightly wider. This difficulty does provide a challenge.
	
**Fast** - Boid starting velocity is 3.2x from Normal and can be accelerated to fabulous speed. Boid is much less controllable than Normal, has lower gravity force on it and less velocity on click. Pipes also much rarer than Normal and they have Easy width, but the gap is really tight. 

While playing on Fast you should know that gap, in fact, plays much lesser role here. Boid will have a very convenient angle to pass through them easily because of it's velocity by x, however gap's location might stop you from getting high score. Alternate RMB with LMB to gain altitude fast and always be prepared if the next gap you see is at low.

**Flat** - Boid behaves normal, pipe gaps like at Easy, but pipe ends are basically making corridor. Really hard difficulty, sometimes unfair. Useful to get good fast at Normal.

**Dense** - Boid behaves like at Fast but even less controllable, however here this is a good thing. Pipes are making solid, continuous corridor. There's no distance between them at all, however, gap random is kinda restricted here to make it possible to play. Starting speed is 1.8x from Normal, pipe gaps are bigger.

**Cave** - Almost like Dense but even less sane, every pipe in corridor is 8px wide. Boid starting speed is normal, but it behaves like at Dense. Random is RELATIVELY less restricted.

**Debug** - The true cave. Will probably replace the current Cave difficulty in the future. It was used as an extreme case for debugging, but now it seem to have better perfomance than mentioned Cave difficulty. Every pipe here is just 1px wide. Boid behaves like at Dense.
