particleGen() 
{
llSetStatus(STATUS_PHYSICS,FALSE);
llSetStatus(STATUS_PHANTOM,TRUE); 
llParticleSystem([
PSYS_PART_FLAGS,           
PSYS_PART_FOLLOW_VELOCITY_MASK| 
PSYS_PART_INTERP_COLOR_MASK|   
PSYS_PART_INTERP_SCALE_MASK|   
PSYS_PART_EMISSIVE_MASK,       
PSYS_SRC_PATTERN,         
PSYS_SRC_PATTERN_ANGLE_CONE,      
PSYS_PART_START_COLOR,llGetColor(ALL_SIDES),
PSYS_PART_END_COLOR,llGetColor(ALL_SIDES), 
PSYS_PART_START_GLOW,  .2,     
PSYS_PART_END_GLOW,    0,     
PSYS_PART_START_ALPHA, .3,      
PSYS_PART_END_ALPHA,   0,     
PSYS_PART_START_SCALE, <.05,1,0>, 
PSYS_PART_END_SCALE,   <0,1,0>,
PSYS_SRC_BURST_RADIUS, 0,     
PSYS_PART_MAX_AGE,5,        
PSYS_SRC_MAX_AGE,.2,          
PSYS_SRC_BURST_RATE, 0.1,    
PSYS_SRC_BURST_PART_COUNT,10, 
PSYS_SRC_TEXTURE,"d937c2a8-950d-54a5-9106-592e5044a9fa",     
PSYS_SRC_BURST_SPEED_MIN,5,   
PSYS_SRC_BURST_SPEED_MAX,10,    
PSYS_SRC_ACCEL, <0,0,-5>,
PSYS_SRC_ANGLE_BEGIN, 1,     
PSYS_SRC_ANGLE_END, 2       
]);
llSleep (0.03); 
}
default
{ 
    state_entry()
    {
    llCollisionSound("",0);
    llSetDamage(100);
    llSetStatus(0x002|0x004|0x008,0);
    }
    collision_start(integer num) 
    {
    particleGen(); 
    llDie();
    }
    land_collision_start(vector pos)
    {
    particleGen();   
    llDie();
    }
    moving_end()
    {
        if(llGetStatus(STATUS_PHYSICS))
        {

        }else{  
        particleGen();   
        llDie();
        }
    }
}
