import { Body, Controller, Get, Param, ParseIntPipe, Post } from '@nestjs/common';
import { AttendanceService } from './attendance.service';
import { CreateAttendanceDto } from './dto/create-attendance.dto';

@Controller('attendance')
export class AttendanceController {
  constructor(private readonly attendanceService: AttendanceService) {}

  @Post()
  async create(@Body() createAttendanceDto: CreateAttendanceDto) {
    const attendance = await this.attendanceService.create(createAttendanceDto);

    return {
      success: true,
      message: 'تم تسجيل الحضور بنجاح',
      data: attendance,
    };
  }

  @Get(':sequentialNumber/count')
  countBySequentialNumber(
    @Param('sequentialNumber', ParseIntPipe) sequentialNumber: number,
  ) {
    return this.attendanceService.countBySequentialNumber(sequentialNumber);
  }
}
