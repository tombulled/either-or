import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'dart:math' as math;
import 'dart:async' as async;

import '../pageRoutes/SwitchPageRoute.dart';
import './ResultScreen.dart';
import '../config/Config.dart';

class ParticlesScreen extends StatelessWidget {
	@override
	Widget build(BuildContext context) {
		return Scaffold (
			body: Particles(),
		);
	}
}

class AnimatedParticle {
	Particle particle;

	AnimationController particleRadiusAnimationController;
	Animation<double> particleRadiusAnimation;

	AnimationController particleOpacityAnimationController;
	Animation<double> particleOpacityAnimation;

	AnimatedParticle ({
		this.particle,
		this.particleRadiusAnimationController,
		this.particleRadiusAnimation,
		this.particleOpacityAnimationController,
		this.particleOpacityAnimation,
	});

	double getRadius() {
		return this.particleRadiusAnimation.value;
	}

	double getOpacity() {
		return this.particleOpacityAnimation.value;
	}

	void startAnimation() {
		this.particleRadiusAnimationController.forward();
		this.particleOpacityAnimationController.forward();

		this.particle.alive = true;
	}

	void dispose() {
		this.particleRadiusAnimationController.dispose();
		this.particleOpacityAnimationController.dispose();
	}
}

class Particles extends StatefulWidget {
	final int totalParticles;
	final Tween<double> particleRadiusTween;
	final Tween<double> particleOpacityTween;
	final Duration animationDuration;
	final Duration particleAnimationDuration;
	final Duration lastParticleAnimationDuration;
	final Duration animationDelay;
	final List<Color> colours;

	Particles ({
		Key key,
		this.totalParticles,
		this.particleRadiusTween,
		this.particleOpacityTween,
		this.animationDuration,
		this.particleAnimationDuration,
		this.lastParticleAnimationDuration,
		this.animationDelay,
		this.colours,
	}) : super(key: key);

    @override
    ParticlesState createState() => ParticlesState();
}

class ParticlesState extends State<Particles> with TickerProviderStateMixin {
    AnimationController lifecycleAnimationController;
    Animation<int> lifecycleAnimation;

	List<AnimatedParticle> animatedParticles = [];

    int _currentParticleIndex = -1;

	int _totalParticles;
	Tween<double> _particleRadiusTween;
	Tween<double> _particleOpacityTween;
	Duration _animationDuration;
	Duration _particleAnimationDuration;
	Duration _lastParticleAnimationDuration;
	Duration _animationDelay;
	List<Color> _colours;

    @override
    void initState() {
        super.initState();

		this._totalParticles = (widget.totalParticles != null && widget.totalParticles > 0) ? widget.totalParticles : 10;
		this._animationDuration = widget.animationDuration ?? Duration(milliseconds: 3000);
		this._particleAnimationDuration = widget.particleAnimationDuration ?? Duration(milliseconds: 1500);
		this._lastParticleAnimationDuration = widget.lastParticleAnimationDuration ?? Duration(milliseconds: 500);
		this._particleRadiusTween = widget.particleRadiusTween ?? Tween(begin: 0, end: 300);
		this._particleOpacityTween = widget.particleOpacityTween ?? Tween(begin: 0, end: 1);
		this._animationDelay = widget.animationDelay ?? Duration(milliseconds: 200);
		this._colours = widget.colours ?? Config.colours;

        for (int index = 0; index < this._totalParticles; index ++) {
			Particle particle = Particle (
				colour: this._colours[math.Random().nextInt(this._colours.length)],
			);

			Duration particleAnimationDuration;

			if (index == this._totalParticles - 1) {
				particleAnimationDuration = this._lastParticleAnimationDuration;
			}
			else {
				particleAnimationDuration = this._particleAnimationDuration;
			}

			AnimationController particleRadiusAnimationController = AnimationController (
				duration: particleAnimationDuration,
				vsync: this,
			);
			AnimationController particleOpacityAnimationController = AnimationController (
				duration: particleAnimationDuration ~/ 2,
				vsync: this,
			);

			Animation<double> particleRadiusAnimation = this._particleRadiusTween.animate(particleRadiusAnimationController);
			Animation<double> particleOpacityAnimation = this._particleOpacityTween.animate(particleOpacityAnimationController);

			particleRadiusAnimation.addListener(() {
				setState(() {});
			});

			particleOpacityAnimation.addListener(() {
				setState(() {});
			});

			particleRadiusAnimation.addStatusListener((status) {
				if (status == AnimationStatus.completed && index == this._totalParticles - 1) {
					this.finishAnimation();
				}

				setState(() {});
			});

			particleOpacityAnimation.addStatusListener((status) {
				if (status == AnimationStatus.completed && index != this._totalParticles - 1) {
					particleOpacityAnimationController.reverse();
				}

				setState(() {});
			});

			AnimatedParticle animatedParticle = AnimatedParticle (
				particle: particle,
				particleRadiusAnimationController: particleRadiusAnimationController,
				particleRadiusAnimation: particleRadiusAnimation,
				particleOpacityAnimationController: particleOpacityAnimationController,
				particleOpacityAnimation: particleOpacityAnimation,
			);

			this.animatedParticles.add(animatedParticle);
        }
        
        this.lifecycleAnimationController = AnimationController (
			duration: this._animationDuration,
			vsync: this,
        );

        Tween<int> lifecycleTween = IntTween (
			begin: 0,
			end: this._totalParticles - 1,
		);

        this.lifecycleAnimation = lifecycleTween.animate(this.lifecycleAnimationController);

		this.lifecycleAnimation.addListener(() {
			int currentParticleIndex = this.lifecycleAnimation.value;

			if (currentParticleIndex != this._currentParticleIndex) {
				this._currentParticleIndex = currentParticleIndex;

				AnimatedParticle animatedParticle = this.animatedParticles[currentParticleIndex];
				Particle particle = animatedParticle.particle;

				particle.offset = Offset (
					math.Random().nextDouble() * MediaQuery.of(context).size.width,
					math.Random().nextDouble() * MediaQuery.of(context).size.height,
				);

				animatedParticle.startAnimation();
			}

			setState(() {});
		});

		async.Timer(this._animationDelay, this.lifecycleAnimationController.forward);
    }

    @override
    void dispose() {
		this.animatedParticles.forEach((AnimatedParticle animatedParticle) => animatedParticle.dispose());
		this.lifecycleAnimationController.dispose();
		super.dispose();
    }

    @override
    Widget build(BuildContext context) {
        return CustomPaint (
			foregroundPainter: ParticlesPainter (
				controller: this.lifecycleAnimationController,
				particles: this.animatedParticles,
			),
		);
    }

	void finishAnimation() {
		AnimatedParticle lastAnimatedParticle = this.animatedParticles[this.animatedParticles.length - 1];
		Particle lastParticle = lastAnimatedParticle.particle;

		double maxParticleRadius = [
			// Distance to top left
			math.sqrt (
				math.pow(lastParticle.offset.dx, 2)
				+ math.pow(lastParticle.offset.dy, 2)
			),
			// Distance to bottom left
			math.sqrt (
				math.pow(lastParticle.offset.dx, 2)
				+ math.pow(MediaQuery.of(context).size.height - lastParticle.offset.dy, 2)
			),
			// Distance to top right
			math.sqrt (
				math.pow(MediaQuery.of(context).size.width - lastParticle.offset.dx, 2)
				+ math.pow(lastParticle.offset.dy, 2)
			),
			// Distance to bottom right
			math.sqrt (
				math.pow(MediaQuery.of(context).size.width - lastParticle.offset.dx, 2)
				+ math.pow(MediaQuery.of(context).size.height - lastParticle.offset.dy, 2)
			),
		].reduce(math.max);

		Duration particleAnimationDuration = Duration (
			milliseconds: (
				(this._lastParticleAnimationDuration.inMilliseconds / this._particleRadiusTween.end)
				* math.max(maxParticleRadius - this._particleRadiusTween.end, 0)
			).round(),
		);

		AnimationController particleRadiusAnimationController = AnimationController (
			duration: particleAnimationDuration,
			vsync: this,
		);
		AnimationController particleOpacityAnimationController = AnimationController (
			duration: particleAnimationDuration,
			vsync: this,
		);

		Tween<double> particleRadiusTween = Tween (
			begin: this._particleRadiusTween.end,
			end: maxParticleRadius,
		);
		Tween<double> particleOpacityTween = Tween (
			begin: 1,
			end: 1,
		);

		Animation<double> particleRadiusAnimation = particleRadiusTween.animate(particleRadiusAnimationController);
		Animation<double> particleOpacityAnimation = particleOpacityTween.animate(particleOpacityAnimationController);

		particleRadiusAnimation.addListener(() {
			setState(() {});
		});

		particleOpacityAnimation.addListener(() {
			setState(() {});
		});

		particleRadiusAnimation.addStatusListener((status) {
			setState(() {});
		});

		particleOpacityAnimation.addStatusListener((status) {
			setState(() {});
		});

		AnimatedParticle animatedParticle = AnimatedParticle (
			particle: lastParticle,
			particleRadiusAnimationController: particleRadiusAnimationController,
			particleRadiusAnimation: particleRadiusAnimation,
			particleOpacityAnimationController: particleOpacityAnimationController,
			particleOpacityAnimation: particleOpacityAnimation,
		);

		this.animatedParticles[this.animatedParticles.length - 1] = animatedParticle;

		this.lifecycleAnimationController = AnimationController (
			duration: particleAnimationDuration,
			vsync: this,
		);

		Tween<int> lifecycleTween = IntTween (
			begin: 0,
			end: 1,
		);

		this.lifecycleAnimation = lifecycleTween.animate(this.lifecycleAnimationController);

		this.lifecycleAnimation.addListener(() {
			setState(() {});
		});

		this.lifecycleAnimation.addStatusListener((AnimationStatus status) {
			if (status == AnimationStatus.completed) {
				Navigator.of(context).pushReplacement (
					SwitchPageRoute (
						page: ResultScreen (
							colour: lastParticle.colour,
						)
					)
				);
			}

			setState(() {});
		});

		this.lifecycleAnimationController.forward();

		animatedParticle.startAnimation();

		setState(() {});
	}
}

class ParticlesPainter extends CustomPainter {
    List<AnimatedParticle> particles;
    AnimationController controller;

    ParticlesPainter({this.controller, this.particles});

    @override
    void paint(Canvas canvas, Size canvasSize) {
		this.particles.forEach((AnimatedParticle animatedParticle) {
			Particle particle = animatedParticle.particle;
			double particleRadius = animatedParticle.getRadius();
			double particleOpacity = animatedParticle.getOpacity();

			if (particle.alive) {
				particle.paint (
					canvas,
					canvasSize,
					opacity: particleOpacity,
					radius: particleRadius,
				);
			}
		});
    }

    @override
    bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class Particle {
	Color _colour;
	Offset _offset;
	bool _alive = false;

    Particle ({
		offset,
		colour,
	}) {
		this._colour = colour;
		this._offset = offset;
	}

	bool get alive => this._alive; 
	Color get colour => this._colour;
	Offset get offset => this._offset;

	set alive(bool alive) => this._alive = alive;
	set colour(Color colour) => this._colour = colour;
	set offset(Offset offset) => this._offset = offset;

    void paint(Canvas canvas, Size canvasSize, {double opacity, double radius}) {
		Paint paint = new Paint();

        paint.color = this.colour.withOpacity(opacity);
        paint.strokeCap = StrokeCap.round;
        paint.style = PaintingStyle.fill;

        canvas.drawCircle(this.offset, radius, paint);
    }
}