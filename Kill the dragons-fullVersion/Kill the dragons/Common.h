

#ifndef Kill_the_dragons_Header_h
#define Kill_the_dragons_Header_h

static const uint32_t weaponCategory = 0x1 << 0;
static const uint32_t enemyCategory  = 0x1 << 1;
static const uint32_t enemyWeaponCategory = 0x1 << 2;
static const uint32_t playerCategory = 0x1 << 3;
static const uint32_t bonusCategory  = 0x1 << 4;
static const uint32_t shieldCategory  = 0x1 << 5;


static const NSInteger kEnemyZPosition = 10;
static const NSInteger kBonusZPosition = 5;

static const NSInteger kEnemiesOnScreen = 2;
static const CGFloat kPlayerPosition = 0.03;
static const CGFloat stayingTimePerFrame = 0.7;
static const CGFloat walkingTimePerFrame = 0.5;


static NSString* playerName = @"wizard";
static NSString* weaponName = @"weapon";
static NSString* enemyName = @"dragon";
static NSString* enemiesWeaponName = @"dragonFire";
static NSString* bonusName = @"bonus";
static NSString* magicFogName = @"magic";
static NSString* stayAnimationKey = @"stay";
static NSString* walkingAnimationKey = @"walking";
static NSString* moveActionKey = @"moveing";
static NSString* progressBarName = @"progress";
static NSString* progressBackgroundName = @"progressBackground";

#endif
