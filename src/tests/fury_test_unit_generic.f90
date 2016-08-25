!< FURY test of [[unit_generic]].
program fury_test_unit_generic
!-----------------------------------------------------------------------------------------------------------------------------------
!< FURY test of [[unit_generic]].
!-----------------------------------------------------------------------------------------------------------------------------------
use fury
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
type(unit_generic) :: si_force        !< SI force unit.
type(unit_generic) :: si_length       !< SI length unit.
type(unit_generic) :: si_frequency    !< SI frequency unit.
type(unit_generic) :: si_mass         !< SI mass unit.
type(unit_generic) :: si_pressure     !< SI pressure unit.
type(unit_generic) :: si_speed        !< SI speed unit.
type(unit_generic) :: si_time         !< SI time unit.
type(unit_generic) :: a_unit          !< A unit.
logical            :: test_passed(13) !< List of passed tests.
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
test_passed = .false.

si_speed = unit_generic(source='m [length].s-1 [time]')
test_passed(1) = si_speed%stringify(with_dimensions=.true.)=='m.s-1 [length.time-1]'
print "(A,L1)", 'pass implicit dim. exp.:  m [length].s-1 [time] => '//si_speed%stringify(with_dimensions=.true.)//&
                ', is correct? ', test_passed(1)
call si_speed%unset
si_speed = unit_generic(source='m [length].s-1 [time-1]')
test_passed(2) = si_speed%stringify(with_dimensions=.true.)=='m.s-1 [length.time-1]'
print "(A,L1)", 'pass explicit dim. exp.:  m [length].s-1 [time-1] => '//si_speed%stringify(with_dimensions=.true.)//&
                ', is correct? ', test_passed(2)

print "(A)", ''
print "(A)", 'Test unit/unit'
call si_speed%unset
si_length = unit_generic(source='m [length]', name='metre')
si_time = unit_generic(source='s [time]', name='second')
si_speed = unit_generic(source='m [length].s-1 [time]', name='metre/second')
print "(A)", 'si_length = '//si_length%stringify(with_dimensions=.true.)
print "(A)", 'si_speed  = '//si_speed%stringify(with_dimensions=.true.)
print "(A)", 'si_time   = '//si_time%stringify(with_dimensions=.true.)
a_unit = si_length / si_time
test_passed(3) = a_unit == si_speed
print "(A,L1)", 'si_length/si_time = '//a_unit%stringify(with_dimensions=.true.)//', is correct? ', test_passed(3)
print "(A)", 'si_length/si_time name is: '//a_unit%name

print "(A)", ''
print "(A)", 'Test unit*unit'
si_force = unit_generic(source='kg [mass].m [length].s-2 [time-2]', name='newton')
si_mass = unit_generic(source='kg [mass]', name='kilogram')
print "(A)", 'si_force = '//si_force%stringify(with_dimensions=.true.)
print "(A)", 'si_mass = '//si_mass%stringify(with_dimensions=.true.)
call a_unit%unset
a_unit = si_mass * si_length / si_time / si_time
test_passed(4) = a_unit == si_force
print "(A,L1)", 'si_mass*si_length/si_time/si_time = '//a_unit%stringify(with_dimensions=.true.)//', is correct? ', test_passed(4)
print "(A)", 'si_mass*si_length/si_time/si_time name is: '//a_unit%name

print "(A)", ''
print "(A)", 'Test unit+unit'
call a_unit%unset
a_unit = si_mass + si_mass
test_passed(5) = a_unit == si_mass
print "(A,L1)", 'si_mass + si_mass = '//a_unit%stringify(with_dimensions=.true.)//', is correct? ', test_passed(5)
print "(A)", 'si_mass + si_mass name is: '//a_unit%name

print "(A)", ''
print "(A)", 'Test unit-unit'
call a_unit%unset
a_unit = si_mass - si_mass
test_passed(6) = a_unit == si_mass
print "(A,L1)", 'si_mass - si_mass = '//a_unit%stringify(with_dimensions=.true.)//', is correct? ', test_passed(6)
print "(A)", 'si_mass - si_mass name is: '//a_unit%name

print "(A)", ''
print "(A)", 'Test unit**2'
call a_unit%unset
a_unit = si_mass ** 2_I8P
test_passed(7) = a_unit%stringify()=='kg2'
print "(A,L1)", 'si_mass ** 2_I8P = '//a_unit%stringify(with_dimensions=.true.)//', is correct? ', test_passed(7)

a_unit = si_mass ** 2_I4P
test_passed(8) = a_unit%stringify()=='kg2'
print "(A,L1)", 'si_mass ** 2_I4P = '//a_unit%stringify(with_dimensions=.true.)//', is correct? ', test_passed(8)

a_unit = si_mass ** 2_I2P
test_passed(9) = a_unit%stringify()=='kg2'
print "(A,L1)", 'si_mass ** 2_I2P = '//a_unit%stringify(with_dimensions=.true.)//', is correct? ', test_passed(9)

a_unit = si_mass ** 2_I1P
test_passed(10) = a_unit%stringify()=='kg2'
print "(A,L1)", 'si_mass ** 2_I1P = '//a_unit%stringify(with_dimensions=.true.)//', is correct? ', test_passed(10)

print "(A)", ''
print "(A)", 'Test aliases equality'
call a_unit%unset
a_unit = 'Pa[pressure] {pascal}'
si_pressure = 'kg [mass].m-1 [length-1].s-2 [time-2] (Pa[pressure]) {pascal}'
test_passed(11) = a_unit == si_pressure
print "(A,L1)", 'Pa = '//si_pressure%stringify()//', is correct? ', test_passed(11)

test_passed(12) = si_pressure%has_symbol(symbol=a_unit%symbols(1))
print "(A,L1)", si_pressure%stringify(with_alias=.true.)//' has symbol Pa, is correct? ', test_passed(12)

call a_unit%unset
si_frequency = 'Hz [frequency]'
a_unit = unit_generic('s-1 = Hz = hertz [frequency]')/si_frequency
test_passed(13) = a_unit%stringify()=='s0'
print "(A,L1)", 's-1/Hz = '//a_unit%stringify()//', is correct? ', test_passed(13)

print "(A,L1)", new_line('a')//'Are all tests passed? ', all(test_passed)
stop
!-----------------------------------------------------------------------------------------------------------------------------------
endprogram fury_test_unit_generic
