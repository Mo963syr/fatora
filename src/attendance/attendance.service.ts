import { ConflictException, Injectable, NotFoundException } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { User, UserDocument } from '../users/schemas/user.schema';
import { CreateAttendanceDto } from './dto/create-attendance.dto';
import { Attendance, AttendanceDocument } from './attendance.schema';

@Injectable()
export class AttendanceService {
  constructor(
    @InjectModel(Attendance.name)
    private attendanceModel: Model<AttendanceDocument>,
    @InjectModel(User.name)
    private userModel: Model<UserDocument>,
  ) {}

  async create(createAttendanceDto: CreateAttendanceDto): Promise<AttendanceDocument> {
    const user = await this.userModel
      .findOne({ sequentialNumber: createAttendanceDto.sequentialNumber })
      .exec();

    if (!user) {
      throw new NotFoundException('المستخدم غير موجود بهذا الرقم التسلسلي');
    }

    const attendanceDate = new Date(Date.now() + 3 * 60 * 60 * 1000);
    const attendanceDay = attendanceDate.toISOString().slice(0, 10);
    const existingAttendance = await this.attendanceModel
      .findOne({ sequentialNumber: createAttendanceDto.sequentialNumber, attendanceDay })
      .select('_id')
      .exec();

    if (existingAttendance) {
      throw new ConflictException('تم تسجيل حضور هذا الطالب اليوم مسبقاً');
    }

    try {
      return await this.attendanceModel.create({
        ...createAttendanceDto,
        attendanceDate,
        attendanceDay,
      });
    } catch (error) {
      if (
        error &&
        typeof error === 'object' &&
        'code' in error &&
        error.code === 11000
      ) {
        throw new ConflictException('تم تسجيل حضور هذا الطالب اليوم مسبقاً');
      }
      throw error;
    }
  }

  async countBySequentialNumber(sequentialNumber: number) {
    const user = await this.userModel.findOne({ sequentialNumber }).select('_id').exec();

    if (!user) {
      throw new NotFoundException('المستخدم غير موجود بهذا الرقم التسلسلي');
    }

    const attendanceCount = await this.attendanceModel.countDocuments({ sequentialNumber });

    return { sequentialNumber, attendanceCount };
  }
}
